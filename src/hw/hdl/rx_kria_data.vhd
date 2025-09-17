----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2025 02:47:12 PM
-- Design Name: 
-- Module Name: rx_kria_data - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rx_kria_data is
  Port (
    clk   : in std_logic; 
    gtp_rx_clk : in std_logic; 
    rst : in std_logic; 
    gtp_rx_data : in std_logic_vector(31 downto 0); 
    trig    : out std_logic; 
    params  : out pzed_parameters_type
   );
end rx_kria_data;

architecture Behavioral of rx_kria_data is

   type decoder_states is (IDLE, ADDR, DATA); 
   signal state : decoder_states; 
   signal sync_address1  : std_logic_vector(31 downto 0):= (others => '0');
   signal sync_address2  : std_logic_vector(31 downto 0):= (others => '0'); 
   signal address  : std_logic_vector(31 downto 0):= (others => '0'); 
   
   signal rdata1  : std_logic_vector(31 downto 0):= (others => '0'); 
   signal rdata2  : std_logic_vector(31 downto 0):= (others => '0'); 
   signal rdata  : std_logic_vector(31 downto 0):= (others => '0'); 
   
   signal sync1, sync2, sync : std_logic; 
   
    
--  COMPONENT ila_0
--    PORT (
--        clk : IN STD_LOGIC;
--	    probe0 : IN STD_LOGIC; 
--	    probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--	    probe2 : IN STD_LOGIC; 
--	    probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
--	    probe4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--	    probe5 : IN decoder_states;
--	    probe6 : IN STD_LOGIC; 
--	    probe7 : IN STD_LOGIC; 
--	    probe8 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
--    );
--    END COMPONENT; 
    
begin

--    debug : ila_0
--    PORT MAP (
--        clk => clk,
--        probe0 => rst, 
--        probe1 => gtp_rx_data, 
--        probe2 => trig, 
--        probe3 => address, 
--        probe4 => rdata, 
--        probe5 => state,
--        probe6 =>  params.eeprom_trig,
--        probe7 => params.eeprom_readall,
--        probe8 => params.eeprom_wrdata
--    );

    fsm: process(gtp_rx_clk) begin 
            if(rising_edge(gtp_rx_clk)) then 
              if(rst = '1') then 
                state <= IDLE;  
              else 
                case state is
                   when IDLE =>
                        sync1 <= '0'; 
                        if(gtp_rx_data = x"ba5eba11") then 
                            state <= ADDR;
                        end if; 
                   when ADDR =>
                        sync_address1 <= gtp_rx_data; 
                        state <= DATA; 
                   when DATA =>
                        sync1 <= '1'; 
                        rdata1 <= gtp_rx_data; 
                        state <= IDLE;    
                   when others =>
                        state <= IDLE; 
                end case; 
            end if;
        end if;  
    end process; 
    
    sync_addr: process(clk) begin 
        if(rising_edge(clk)) then 
            sync_address2 <= sync_address1; 
            address <= sync_address2; 
        end if; 
    end process;
    
    sync_data: process(clk) begin 
        if(rising_edge(clk)) then 
            rdata2 <= rdata1; 
            rdata <= rdata2; 
        end if; 
    end process;
    
    sync_signal: process(clk) begin 
        if(rising_edge(clk)) then 
            sync2 <= sync1; 
            sync <= sync2; 
        end if; 
    end process;
    
    decoder: process(clk) begin 
       if(rising_edge(clk)) then 
          if(rst = '1') then 
            params.eeprom_trig     <= '0';
            params.eeprom_wrdata   <= 32d"0"; 
            params.eeprom_readall  <= '0';  
            params.trig_out_delay  <= 32d"0";
            params.trig_out_enable <= '0';                
          elsif (sync = '1') then 
            case address(7 downto 0) is 
              when x"00" =>   trig                        <= rdata(0);
              when x"40" =>   params.accum_reset          <= rdata(0); 
              when x"41" =>   params.trig_out_delay       <= rdata;
              when x"42" =>   params.trig_out_enable      <= rdata(0);
              when x"50" =>   params.eeprom_trig          <= rdata(0);
              when x"51" =>   params.eeprom_wrdata        <= rdata;   
              when x"52" =>   params.eeprom_readall       <= rdata(0);  
              when others => null;  
            end case; 
          else 
            trig <= '0'; 
            params.eeprom_trig <= '0'; 
            params.eeprom_readall <= '0'; 
          end if;
        end if;  
    end process; 
    

end Behavioral;
