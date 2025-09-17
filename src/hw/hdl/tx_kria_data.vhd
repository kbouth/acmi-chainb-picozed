----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2025 03:41:44 PM
-- Design Name: 
-- Module Name: tx_kria_data - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 
library work;
use work.acmi_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_kria_data is
  Port ( 
    clk : in std_logic; 
    reset : in std_logic; 
    trig  : in std_logic; 
    adc_data : in std_logic_vector(15 downto 0); 
    eeprom_params : in eeprom_parameters_type;
    tx_data : out std_logic_vector(31 downto 0); 
    tx_data_enb : out std_logic
  );
end tx_kria_data;

architecture Behavioral of tx_kria_data is

    
    COMPONENT adc_fifo
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC 
      );
    END COMPONENT;
    
    signal empty, full : std_logic; 
    signal wr_en, rd_en: std_logic; 
    signal adc_data_in, tx_data_out : std_logic_vector(31 downto 0);
    
    type state is (IDLE, SEND_HEADER,SEND_RESULTS,SEND_SETTINGS,WRITE_FIFO,READ_FIFO,SEND_FOOTER,DONE);

    signal present_state : state := IDLE; 
    signal adc_count : integer := 0; 
    
--    COMPONENT fifo_ila
--    PORT (
--        clk : IN STD_LOGIC;    
--        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--        probe1 : IN STD_LOGIC; 
--        probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--        probe3 : IN STD_LOGIC; 
--        probe4 : IN STD_LOGIC; 
--        probe5 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--        probe6 : IN STD_LOGIC; 
--        probe7 : IN STD_LOGIC; 
--        probe8 : IN state;
--        probe9 : IN integer
--    );
--    END COMPONENT  ;
    
begin
  
    raw_adc_fifo : adc_fifo
      PORT MAP (
        clk => clk,
        srst => reset,
        din => adc_data_in,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => tx_data_out,
        full => full,
        empty => empty
      );
      
      
--    fifo_debug : fifo_ila
--    PORT MAP (
--        clk => clk,
--        probe0 => tx_data, 
--        probe1 => tx_data_enb, 
--        probe2 => adc_data_in, 
--        probe3 => wr_en, 
--        probe4 => rd_en, 
--        probe5 => tx_data_out, 
--        probe6 => full, 
--        probe7 => empty, 
--        probe8 => present_state,
--        probe9 => adc_count
--    );

    fsm: process(clk) begin 
        if(rising_edge(clk)) then 
            if(reset = '1') then 
                wr_en <= '0'; 
                rd_en <= '0'; 
                tx_data_enb <= '0'; 
                adc_count <= 0; 
            else 
                case present_state is
                    when IDLE =>
                        wr_en <= '0';
                        rd_en <= '0';
                        tx_data_enb <= '0';
                        adc_count <= 0;
                        if (full = '0') then
                            present_state <= SEND_HEADER;
                        end if;
                
                    when SEND_HEADER =>
                        tx_data <= x"0000BEEF";
                        tx_data_enb <= '1';
                        present_state <= SEND_RESULTS;
                
                    when SEND_RESULTS =>
                        tx_data_enb <= '1';
                        case adc_count is
                            when 0  => tx_data <= std_logic_vector(to_unsigned(0, 32)); -- version
                            when 1  => tx_data <= std_logic_vector(to_unsigned(0, 32)); -- dummy stat
                            when 2  => tx_data <= std_logic_vector(to_unsigned(0, 32)); -- dummy stat
                            when 3  => tx_data <= std_logic_vector(to_unsigned(0, 32)); -- dummy stat
                            when others =>
                                adc_count <= 0;
                                present_state <= SEND_FOOTER;
                        end case;
                        adc_count <= adc_count + 1;
                
                    when SEND_SETTINGS =>
                        tx_data_enb <= '1';
                        case adc_count is
                            when 0 => tx_data <= eeprom_params.header;
                            when 1 => tx_data <= eeprom_params.tp1_pulse_delay;
                            when 2 => tx_data <= eeprom_params.tp1_pulse_width;
                            when 3 => tx_data <= eeprom_params.tp1_adc_delay;
                            when others =>
                                adc_count <= 0;
                                wr_en <= '1';
                                present_state <=SEND_FOOTER;
                        end case;
                        adc_count <= adc_count + 1;
                
                    when WRITE_FIFO =>
                        tx_data_enb <= '0';
                        if (adc_count < 16000) then
                            adc_data_in <= std_logic_vector(resize(signed(adc_data), 32));
                            adc_count <= adc_count + 1;
                        else
                            wr_en <= '0';
                            adc_count <= 0;
                            rd_en <= '1';
                            present_state <= READ_FIFO;
                        end if;
                
                    when READ_FIFO =>
                        if (adc_count < 16000) then
                            tx_data_enb <= '1';
                            tx_data <= tx_data_out;
                            adc_count <= adc_count + 1;
                        else
                            rd_en <= '0';
                            adc_count <= 0;
                            present_state <= SEND_FOOTER;
                        end if;
                
                    when SEND_FOOTER =>
                        tx_data_enb <= '1';
                        tx_data <= x"DEADBEEF";
                        present_state <= DONE;
                
                    when DONE =>
                        tx_data_enb <= '0';
                        present_state <= IDLE;
                end case;
            end if; 
        end if; 
    end process; 

    
    
end Behavioral;
