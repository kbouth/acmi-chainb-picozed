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
  generic (
    FPGA_VERSION : integer
  );
  Port ( 
    clk : in std_logic; 
    reset : in std_logic; 
    trig  : in std_logic; 
    adc_data : in std_logic_vector(15 downto 0); 
    pulse_stats        : in pulse_stats_array; 
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
    
    type state is (IDLE, BEAM_WINDOW,SEND_RESULTS,SEND_SETTINGS,READ_FIFO);

    signal present_state : state := IDLE; 
    signal count : integer:= 0; 
    signal start : std_logic:= '0'; 
    
    attribute mark_debug                 : string;
    attribute mark_debug of tx_data: signal is "true";
    attribute mark_debug of present_state: signal is "true";
    attribute mark_debug of count: signal is "true";
    attribute mark_debug of tx_data_enb: signal is "true";
    attribute mark_debug of start: signal is "true";
    
begin
    
    start <= trig; 
    
  
    raw_adc_fifo : adc_fifo
      PORT MAP (
        clk => clk,
        srst => trig,
        din => std_logic_vector(resize(signed(adc_data), 32)),
        wr_en => wr_en,
        rd_en => rd_en,
        dout => tx_data_out,
        full => full,
        empty => empty
      );
      

    fsm: process(clk) begin 
        if(rising_edge(clk)) then 
            if(reset = '1') then 
                wr_en <= '0'; 
                rd_en <= '0'; 
                tx_data_enb <= '0'; 
                count <= 0; 
            else 
                case present_state is
                    when IDLE =>
                        wr_en <= '0';
                        rd_en <= '0';
                        tx_data_enb <= '0';
                        count <= 0;
                        if (start = '1') then -- when triggered by trig, start fsm and send results to backend
                            present_state <= BEAM_WINDOW;
                        end if;
                    
                    when BEAM_WINDOW => -- wait until all calc of all four pulses are done. all four pulses should be within this window of 16000 points
                        if(count < 16100) then 
                            count <= count + 1;
                            wr_en <= '1'; 
                        else
                            count <= 0; 
                            wr_en <= '0';
                            present_state <= SEND_RESULTS; 
                        end if; 
               
                
                    when SEND_RESULTS =>
                        tx_data_enb <= '1';
                        if present_state <= SEND_RESULTS then 
                            count <= count + 1;
                        end if; 
                        case count is
                             --header
                             when 0   =>  tx_data   <= x"0000beef";
                             when 1   =>  tx_data   <= std_logic_vector(to_unsigned(FPGA_VERSION,32)); 
                             -- beam pulse stats
                             when 2   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(0).baseline),32));
                             when 3   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(0).peak),32));
                             when 4   =>  tx_data   <= pulse_stats(0).integral;
                             when 5   =>  tx_data   <= std_logic_vector(resize(unsigned(pulse_stats(0).fwhm),32));  
                             when 6   =>  tx_data   <= pulse_stats(0).peak_index; 
                             -- TP1 stats
                             when 7   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(1).baseline),32));
                             when 8   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(1).peak),32));
                             when 9   =>  tx_data   <= pulse_stats(1).integral;
                             when 10  =>  tx_data   <= 16d"0" & pulse_stats(1).fwhm;  
                             when 11  =>  tx_data   <= pulse_stats(1).peak_index;                              
                             -- TP2 stats
                             when 12  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(2).baseline),32));
                             when 13  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(2).peak),32));
                             when 14  =>  tx_data   <= pulse_stats(2).integral;
                             when 15  =>  tx_data   <= 16d"0" & pulse_stats(2).fwhm;  
                             when 16  =>  tx_data   <= pulse_stats(2).peak_index;                                              
                             -- TP3 stats
                             when 17  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(3).baseline),32));
                             when 18  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(3).peak),32));
                             when 19  =>  tx_data   <= pulse_stats(3).integral;
                             when 20  =>  tx_data   <= 16d"0" & pulse_stats(3).fwhm;  
                             when 21  =>  tx_data   <= pulse_stats(3).peak_index; 
                             
                             when 22 =>
                                count <= 0;
                                present_state <= SEND_SETTINGS;
                            when others => null;
                        end case;
                
                    when SEND_SETTINGS =>
                        tx_data_enb <= '1';
                        if present_state <= SEND_SETTINGS then 
                        count <= count + 1;
                        end if; 
                        case count is
                             when 0   =>  tx_data   <= eeprom_params.header;           
                             when 1   =>  tx_data   <= eeprom_params.tp1_pulse_delay; 
                             when 2   =>  tx_data   <= eeprom_params.tp1_pulse_width;     
                             when 3   =>  tx_data   <= eeprom_params.tp1_adc_delay;     
                             when 4   =>  tx_data   <= eeprom_params.tp2_pulse_delay; 
                             when 5   =>  tx_data   <= eeprom_params.tp2_pulse_width;     
                             when 6  =>  tx_data   <= eeprom_params.tp2_adc_delay;                 
                             when 7  =>  tx_data   <= eeprom_params.tp3_pulse_delay; 
                             when 8  =>  tx_data   <= eeprom_params.tp3_pulse_width;    
                             when 9  =>  tx_data   <= eeprom_params.tp3_adc_delay;                  
                             when 10  =>  tx_data   <= eeprom_params.beam_adc_delay; 
                             when 11 =>
                                    count <= 0;
                                    present_state <= READ_FIFO;
                             when others => null;
                        end case;
                      
                        
                    when READ_FIFO =>
                        if (count < 16000) then
                            rd_en <= '1';
                            tx_data <= tx_data_out;
                            count <= count + 1;
                        else
                            rd_en <= '0';
                            count <= 0;
                            present_state <= IDLE;
                        end if;
                
                end case;
            end if; 
        end if; 
    end process; 

    
    
end Behavioral;
