----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2025 04:24:41 PM
-- Design Name: 
-- Module Name: calc_baseline - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calc_baseline is
  Port ( 
    clk  : in std_logic; 
    trig : in std_logic;
    adc_data: in signed(15 downto 0); 
    baseline : out signed(31 downto 0) 
  );
end calc_baseline;

architecture Behavioral of calc_baseline is

  signal baseline_sum : signed(31 downto 0) := (others => '0');  
  signal baseline_avg : signed(31 downto 0) := (others => '0'); 
  

  constant BASELINE_LEN : unsigned(7 downto 0) := to_unsigned(32, 8);
  signal   active_cnt     : unsigned(7 downto 0) := (others => '0');

  type state is (IDLE, SUM, AVG);
  signal present_state : state := IDLE;
  
begin

    baseline_fsm: process(clk) begin 
        if(rising_edge(clk)) then 
            case(present_state) is 
                when IDLE => 
                    if(trig = '1') then 
                        baseline_sum <= 32d"0"; 
                        active_cnt <= 8d"0";
                        present_state <= SUM;  
                    end if; 
                
                when SUM => 
                    if(active_cnt = BASELINE_LEN - 1) then 
                        present_state <= AVG; 
                    else 
                        baseline_sum <= baseline_sum + resize(adc_data,32);
                        active_cnt <= active_cnt + 1; 
                    end if; 
                when AVG =>
                    baseline_avg <= baseline_sum sra 5;
                    present_state <= IDLE; 
                when others =>
                    present_state <= IDLE; 
            end case; 
        end if; 
    end process; 
    
    baseline <= baseline_avg; 
    
end Behavioral;
