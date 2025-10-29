----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2025 10:19:34 AM
-- Design Name: 
-- Module Name: artix_spi - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity artix_spi is
  Port (
        clk : in std_logic; 
        sclk : in std_logic; 
        csn  : in std_logic; 
        din  : in std_logic; 
        dout : out std_logic;
        trig : out std_logic;  
        params : out pzed_parameters_type
   );
end artix_spi;

architecture Behavioral of artix_spi is
    type state is (IDLE, TRANS, DONE); 
    signal present_state : state := IDLE; 
    signal csn_sync : std_logic_vector(2 downto 0);
    signal sclk_sync : std_logic_vector(2 downto 0);
    signal din_sync  : std_logic_vector(2 downto 0);
    signal address : std_logic_vector(31 downto 0); 
    signal rdata  : std_logic_vector(31 downto 0); 
    
    signal sclk_rise: std_logic;
    signal csn_active : std_logic;
    signal bit_count : integer := 0; 
    
--    attribute mark_debug                 : string;
--    attribute mark_debug of sclk_rise: signal is "true";
--    attribute mark_debug of csn_active: signal is "true"; 
--    attribute mark_debug of bit_count : signal is "true"; 
--    attribute mark_debug of present_state : signal is "true"; 
--    attribute mark_debug of address : signal is "true"; 
--    attribute mark_debug of rdata   : signal is "true"; 
--    attribute mark_debug of sclk_sync : signal is "true"; 
--    attribute mark_debug of csn_sync  : signal is "true"; 
--    attribute mark_debug of din_sync : signal is "true"; 
    
    
begin

    sclk_rise <= '1' when (sclk_sync(2)='0' and sclk_sync(1)='1') else '0';
    csn_active <= not csn_sync(2);  -- active low
    
    process(clk)
    begin
      if rising_edge(clk) then
        csn_sync  <= csn_sync(1 downto 0) & csn; 
        sclk_sync <= sclk_sync(1 downto 0) & sclk; 
        din_sync <= din_sync(1 downto 0) & din; 
      end if;
    end process;

    spi_fsm: process(clk) begin 
        if(rising_edge(clk)) then 
                
                case (present_state) is 
                    when IDLE => 
                        bit_count <= 63; 
                        if(csn_active = '1') then             
                            present_state <= TRANS; 
                        end if; 
            
            
                    when TRANS =>
                      
                      if( sclk_rise='1') then 
                       
                          if(bit_count >= 32) then 
                            address(bit_count - 32) <= din_sync(2);
                          else   
                            rdata(bit_count) <= din_sync(2); 
                           end if; 
                           
                           if(bit_count = 0) then  
                                present_state <= DONE; 
                           else 
                                bit_count <= bit_count - 1; 
                           end if;  
                         
                     end if; 
            
                        
                    when DONE => 
                        if(csn_sync = "111") then  
                            present_state <= IDLE; 
                        end if; 
                end case; 
        end if; 
    end process; 
    
    decoder: process(clk) begin 
        if(rising_edge(clk)) then 
            if(present_state = DONE) then 
                case address is 
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
