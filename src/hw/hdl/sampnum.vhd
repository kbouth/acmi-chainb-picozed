----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2025 11:18:04 AM
-- Design Name: 
-- Module Name: sampnum - Behavioral
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

entity sampnum is
  Port (
        clk : in std_logic; 
        trig : in std_logic; 
        sampnum : out std_logic_vector(31 downto 0):= (others => '0')
   );
end sampnum;

architecture Behavioral of sampnum is

begin
    
    gen_sampnum : process(clk) begin 
        if (rising_edge(clk)) then     
            if(trig = '1') then 
                sampnum <= 32d"0";
            else 
                sampnum <= sampnum + 1; 
            end if;  
        end if; 
    end process; 

end Behavioral;
