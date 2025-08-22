----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2025 11:20:53 AM
-- Design Name: 
-- Module Name: ACMI_tpg - Behavioral
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
-- any Xilinx leaf cells out this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_gen is
  Port (
        sys_clk    :in std_logic;
        reset      :in std_logic; 
        event_trig :in std_logic;  
        tp_width   :in std_logic_vector(31 downto 0);
        tp_delay   :in std_logic_vector(31 downto 0); 
        pulse      :out std_logic
   );
end pulse_gen;

architecture Behavioral of pulse_gen is
    signal global_cnt  : integer:= 0; 
    signal width_stop  : integer:= 0;
    signal delay_stop  : integer:= 0; 
    signal finish      : std_logic := '0'; 
    signal prev_trig   : std_logic := '0'; 
    
    type STATE is (IDLE, DELAY,PULSE_START, STOP);
    signal present_state : STATE := IDLE; 
begin
   
   process(sys_clk) begin 
    if(rising_edge(sys_clk)) then 
        prev_trig <= event_trig;     
    end if;
   end process; 
    
   fsm: process(sys_clk) begin 
     if(rising_edge(sys_clk)) then 
            if(reset = '1') then 
                global_cnt <= 0; 
                pulse <= '0';
                present_state <= IDLE;
            else 
            
                 case present_state is
                    when IDLE => 
                    
                        global_cnt <= 0; 
                        delay_stop <= to_integer(unsigned(tp_delay))-1;
                        width_stop <= to_integer(unsigned(tp_delay)) + to_integer(unsigned(tp_width)) - 1;
                        pulse <= '0';
                        
                        if(prev_trig = '0' and event_trig = '1') then 
                            present_state <= DELAY; 
                        else 
                            present_state <= IDLE;  
                        end if; 
                    
                    when DELAY =>
                    
                        global_cnt <= global_cnt + 1; 
                        pulse <= '0';
                        
                        if(global_cnt = delay_stop) then 
                            present_state <= PULSE_START; 
                        else 
                            present_state <= DELAY; 
                        end if; 
                        
                   when PULSE_START =>
                   
                        global_cnt <= global_cnt + 1; 
                        pulse <= '1';  
                        
                        if(global_cnt = width_stop) then 
                            present_state <= STOP; 
                        else 
                            present_state <= PULSE_START; 
                        end if;
                        
                  when STOP =>
                  
                        pulse <= '1'; 
                        
                        present_state <= IDLE;              
                 
                 end case; 
            end if; 
        end if; 
   end process; 
    

end Behavioral;
