----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2025 09:50:06 AM
-- Design Name: 
-- Module Name: gen_pulse - Behavioral
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
library work;
use work.acmi_package.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trig_pulse is
  Port (
    clk   : in std_logic; 
    trig  : in std_logic; 
    delay : in std_logic_vector(31 downto 0); 
    width : in std_logic_vector(15 downto 0); 
    pulse : out std_logic
   );
end trig_pulse;

architecture Behavioral of trig_pulse is
    type pulse_state is (IDLE, DELAY_P, PULSE_GEN); 
    signal present_state : pulse_state:= IDLE; 
    signal count : integer:= 0; 
    signal prev_trig : std_logic; 
    
begin
    
    fsm: process(clk) begin 
        if(rising_edge(clk)) then 
        
            prev_trig <= trig; 
            
            case(present_state) is 
                when IDLE =>
                    count <= 0;
                    pulse <= '0';  
                    if(prev_trig = '0' and trig = '1') then 
                        present_state <= DELAY_P;
                        count <= 0 when (delay = 32d"0") else to_integer(unsigned(delay)) - 1 ; 
                    end if; 
                when DELAY_P=> 
                    if(count = 0) then 
                        count <= 0 when (width = 16d"0") else to_integer(unsigned(width)) - 1 ; 
                        present_state <= PULSE_GEN; 
                    else 
                        count <= count - 1; 
                    end if; 
                
                when PULSE_GEN => 
                     if(count = 0) then
                        pulse <= '0';  
                        present_state <= IDLE; 
                    else 
                        pulse <= '1'; 
                        count <= count - 1; 
                    end if;                
                
            end case; 
        end if;
    end process;  
    
    
    
end Behavioral;
