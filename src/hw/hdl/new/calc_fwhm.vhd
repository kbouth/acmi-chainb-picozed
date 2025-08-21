----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2025 10:26:40 AM
-- Design Name: 
-- Module Name: calc_fwhm - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calc_fwhm is
  Port (
    clk : in std_logic; 
    trig : in std_logic; 
    peak_val : in signed(15 downto 0);
    adc_data_dly : in signed(15 downto 0); 
    fwhm  : out std_logic_vector(15 downto 0)
   );
end calc_fwhm;

architecture Behavioral of calc_fwhm is
    
    type state is (IDLE,TRIGG,START_FWHM,STOP_FWHM); 
    signal present_state : state := IDLE; 
    signal fwhm_level : signed(15 downto 0); 
    signal fwhm_val    : unsigned(15 downto 0); 
    
begin
    
    
    fwhm_fsm : process(clk) begin 
        if(rising_edge(clk)) then 
            case present_state is 
                when IDLE =>
                    if(trig = '1') then  
                        fwhm_level <= peak_val / 2;
                        fwhm_val <= 16d"0"; 
                        present_state <= TRIGG; 
                    end if; 
                when TRIGG => 
                    if(abs(adc_data_dly) >= abs(fwhm_level)) then 
                        fwhm_val <= fwhm_val + 1; 
                        present_state <= START_FWHM; 
                    end if;  
                
                when START_FWHM => 
                    if(abs(adc_data_dly) <= abs(fwhm_level)) then  
                        present_state <= STOP_FWHM; 
                    else 
                        fwhm_val <= fwhm_val + 1; 
                    end if;  
                
                when STOP_FWHM => 
                    fwhm <= std_logic_vector(fwhm_val); 
                    present_state <= IDLE; 
            end case; 
        end if; 
    end process; 

end Behavioral;
