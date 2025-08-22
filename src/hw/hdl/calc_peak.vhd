----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2025 04:25:04 PM
-- Design Name: 
-- Module Name: calc_peak - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calc_peak is
  Port ( 
    clk : in std_logic; 
    trig : in std_logic;
    adc_data : in signed(15 downto 0); 
    samp_num : in std_logic_vector(31 downto 0); 
    peak_val : out signed(15 downto 0); 
    peak_idx : out std_logic_vector(31 downto 0); 
    peak_found : out std_logic
  );
end calc_peak;

architecture Behavioral of calc_peak is

    type state is (IDLE, PEAK, DONE); 
    signal present_state : state := IDLE; 
     
    signal peak_index : std_logic_vector(31 downto 0):=(others => '0');
    signal peak_temp  : signed(15 downto 0):=(others => '0');  
    signal index : std_logic_vector(31 downto 0):= (others => '0'); 
    

begin


    peak_fsm: process(clk) begin 
        if(rising_edge(clk)) then 
            case present_state is
                when IDLE => 
                    peak_found <= '0'; 
                    
                    if(trig = '1') then 
                        present_state <= PEAK; 
                    end if; 

                when PEAK => 
                
                    if(abs(adc_data) > abs(peak_temp)) then 
                       peak_index <= samp_num;
                       peak_temp <= adc_data; 
                    end if; 
                        
                    if(trig = '0') then 
                        peak_val <= peak_temp; 
                        peak_idx <= peak_index;  
                        present_state <= DONE; 
                    end if;               
                    
                when DONE =>               
                    peak_found <= '1'; 
                    present_state <= IDLE;  
                when others =>
                    present_state <= IDLE; 
            end case; 
        end if; 
    end process; 
    

    
end Behavioral;
