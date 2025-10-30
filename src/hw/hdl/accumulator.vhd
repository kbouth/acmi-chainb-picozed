----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2025 08:13:04 AM
-- Design Name: 
-- Module Name: accumulator - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity accumulator is
  Port ( 
    clk : in std_logic; 
    rst : in std_logic; 
    accum_len : in std_logic_vector(12 downto 0); 
    trig    : in std_logic; 
    q_min   : in std_logic_vector(31 downto 0) ;
    sample   : in std_logic_vector(31 downto 0); 
    accum    : out std_logic_vector(31 downto 0)
  );
end accumulator;

architecture Behavioral of accumulator is

    COMPONENT accum_circ_buff
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        rstb : IN STD_LOGIC;
        addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rsta_busy : OUT STD_LOGIC;
        rstb_busy : OUT STD_LOGIC 
      );
    END COMPONENT;

    type state is (IDLE, DELAY, NEW_SAMPLE, ADD, UPDATE_PTRS); 
    signal present_state: state:= IDLE; 
    signal cnt : integer:= 0; 
    signal new_samp, old_samp : std_logic_vector(31 downto 0); 
    signal wr_ptr, rd_ptr : std_logic_vector(12 downto 0); 
    signal buffcnt  : std_logic_vector(12 downto 0); 
    signal full  : std_logic:= '0'; 
    signal wr_en : std_logic:= '0'; 
    signal prev_trig : std_logic; 
    
   attribute mark_debug                 : string;
   attribute mark_debug of sample: signal is "true";
   attribute mark_debug of new_samp: signal is "true";
   attribute mark_debug of old_samp: signal is "true";
   attribute mark_debug of wr_ptr: signal is "true";
   attribute mark_debug of rd_ptr: signal is "true";
   attribute mark_debug  of buffcnt: signal is "true"; 
   attribute mark_debug of wr_en: signal is "true"; 
   attribute mark_debug of cnt: signal is "true"; 
   attribute mark_debug of present_state: signal is "true"; 
   attribute mark_debug of accum_len: signal is "true"; 
   attribute mark_debug of q_min: signal is "true"; 
   attribute mark_debug of accum: signal is "true"; 
   
begin

 accum_buff : accum_circ_buff
  PORT MAP (
    clka => clk,
    wea => wr_en,
    addra => wr_ptr,
    dina => new_samp,
    clkb => clk,
    rstb => rst,
    addrb => rd_ptr,
    doutb => old_samp,
    rsta_busy => open,
    rstb_busy => open
  );
  
  accum_fsm : process(clk) begin 
    if(rising_edge(clk)) then 
        prev_trig <= trig; 
        
        if(rst = '1') then 
            buffcnt <= 13d"0"; 
            new_samp <= 32d"0";
            full <= '0'; 
            wr_ptr <= 13d"0"; 
            rd_ptr <= 13d"1"; 
            wr_en <= '0'; 
            accum <= 32d"0";    
        else 
            case present_state is 
                when IDLE =>
                
                    if(prev_trig = '0' and trig <= '1') then 
                        present_state <= DELAY; 
                    end if; 
                
                when DELAY => 
                    
                    if(cnt = 2000) then 
                        cnt <= 0; 
                        present_state <= NEW_SAMPLE; 
                    else 
                        cnt <= cnt + 1; 
                    end if; 
                    
                when NEW_SAMPLE=> 
                    
                    if(sample > q_min) then 
                        new_samp <= sample;
                    else 
                        new_samp <= q_min; 
                    end if; 
                    
                    if(buffcnt >= accum_len) then 
                        full <= '1'; 
                    else
                        buffcnt <= buffcnt + 1; 
                    end if; 
                    
                    present_state <= ADD; 
                    
                when ADD => 
                
                    if(full) then 
                        accum <= accum + new_samp - old_samp; 
                    else 
                        accum <= accum + new_samp; 
                    end if; 
                    
                    present_state <= UPDATE_PTRS; 
                    wr_en <= '1';                 
                    
                when UPDATE_PTRS => 
                    
                    wr_ptr <= rd_ptr; 
                    wr_en <= '0'; 
                    
                    if(rd_ptr = accum_len) then 
                        rd_ptr <= 13d"0"; 
                    else
                        rd_ptr <= rd_ptr + 1; 
                    end if; 
                    
                    present_state <= IDLE; 
                    
                when others => present_state <= IDLE;
            
            
            end case; 
        end if; 
    end if; 
  end process; 

end Behavioral;
