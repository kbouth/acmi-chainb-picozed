----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2025 03:30:10 PM
-- Design Name: 
-- Module Name: calc_stats - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.acmi_package.ALL;

entity calc_stats is
  Port ( 
   clk              : in std_logic;
   trig             : in std_logic;
   adc_data         : in signed(15 downto 0);
   adc_data_dly     : in signed(15 downto 0);
   gate_start       : in std_logic_vector(31 downto 0);
   adc_samplenum    : in std_logic_vector(31 downto 0);
   polarity         : in std_logic; 
   pulse_stats      : out pulse_stats_type
  );
end calc_stats;

architecture Behavioral of calc_stats is
    
    signal baseline_start : std_logic:= '0'; 
    signal integration_start: std_logic:= '0'; 
    type state is (IDLE,TRIGG,BASELINE,INTEG); 
    signal present_state : state := IDLE; 
    signal active_cnt : std_logic_vector(7 downto 0) := 8d"0"; 

    type adc_buffer_t is array(0 to 127) of signed(15 downto 0);
    signal adc_buffer : adc_buffer_t := (others => (others => '0'));
    
    constant BASELINE_LEN     : std_logic_vector(7 downto 0) := 8d"32";
    constant INTEGRAL_LEN     : std_logic_vector(7 downto 0) := 8d"40";
    
    signal baseline_avg : signed(31 downto 0); 
    signal integration : signed(31 downto 0); 
    
    signal peak_val     : signed(15 downto 0);
    signal peak_idx     : std_logic_vector(31 downto 0):= (others => '0');
    signal peak_found   : std_logic; 
    signal sample_index : integer range 0 to 127 := 0;
    
    signal fake_adc : signed(15 downto 0); 
    signal fwhm     : std_logic_vector(15 downto 0); 
    

begin
    

    pulse_fsm : process(clk) begin 
        if(rising_edge(clk)) then 
            case(present_state) is
                when IDLE =>
                    if(trig = '1') then 
                        baseline_start <= '0'; 
                        integration_start <= '0';
                        active_cnt <= 8d"0";  
                        present_state <= TRIGG; 
                    end if; 
                
                when TRIGG => 
                    if(adc_samplenum = gate_start) then 
                        baseline_start <= '1'; 
                        active_cnt <= BASELINE_LEN - 1;
                        present_state <= BASELINE; 
                    end if;  
               
                    
                when BASELINE => 
                    if(active_cnt = 0) then 
                        baseline_start <= '0'; 
                        active_cnt <= INTEGRAL_LEN - 1;
                        present_state <= INTEG; 
                    else 
                        baseline_start <= '1'; 
                        active_cnt <= active_cnt - 1; 
                    end if; 
                
                when INTEG => 
                    if(active_cnt = 0) then 
                        integration_start <= '0'; 
                        active_cnt <= 8d"0";
                        present_state <= IDLE; 
                    else 
                        integration_start <= '1'; 
                        active_cnt <= active_cnt - 1; 
                    end if;  
                
                when others => 
                    present_state <= IDLE;                   
                 
            end case; 
        end if; 
    end process; 
    
    baseline_pulse: entity work.calc_baseline
        port map(
            clk => clk,
            trig => baseline_start,
            adc_data => adc_data,
            baseline => baseline_avg
        ); 
        
    integration_pulse: entity work.calc_integ
        port map(
            clk => clk,
            trig => integration_start,
            adc_data => adc_data,
            baseline => baseline_avg,
            polarity => polarity,
            integration => integration
        ); 
        
     peak_pulse : entity work.calc_peak
        port map(
            clk => clk,
            trig => integration_start,
            adc_data => adc_data,
            samp_num => adc_samplenum,
            polarity => polarity,
            peak_val => peak_val,
            peak_idx => peak_idx,
            peak_found => peak_found
        ); 
        
     fwhm_pulse : entity work.calc_fwhm
        port map(
            clk => clk,
            trig => peak_found,
            peak_val => peak_val,
            adc_data_dly => adc_data_dly,
            fwhm => fwhm
        ); 

    pulse_stats.baseline <= std_logic_vector(baseline_avg(15 downto 0));  -- truncate to 16 bits
    pulse_stats.integral <= std_logic_vector(integration);  -- already 32-bit
    pulse_stats.peak       <= std_logic_vector(resize(peak_val,17));
    pulse_stats.peak_index <= peak_idx;
    pulse_stats.peak_found <= peak_found;
    pulse_stats.threshold  <= (others => '0');
    pulse_stats.fwhm       <= fwhm;


end Behavioral;
