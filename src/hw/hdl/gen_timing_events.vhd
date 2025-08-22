----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/20/2025 09:26:37 AM
-- Design Name: 
-- Module Name: gen_timing_events - Behavioral
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

entity gen_timing_events is
  Port ( 
    clk     : in std_logic; 
    reset   : in std_logic; 
    eeprom_rdy : in std_logic; 
    trig     : in std_logic; 
    eeprom_params    : in eeprom_parameters_type;
    cntrl_params     : in pzed_parameters_type;
--    acis_keylock   : in std_logic; 
--    beam_detect_window  : out std_logic; 
--    beam_cycle_window : out std_logic; 
    adc_samplenum   : out std_logic_vector(31 downto 0); 
    tp_pos_pulse    : out std_logic_vector(4 downto 0); 
    tp_neg_pulse    : out std_logic_vector(4 downto 0)
--    timestamp       : out std_logic_vector(31 downto 0); 
--    watchdog_clock  : out std_logic; 
--    watchdog_pulse  : out std_logic; 
--    startup_cnt     : out std_logic_vector(31 downto 0); 
--    fault_startup   : out std_logic; 
--    fp_trig_dly_out : out std_logic
  );
end gen_timing_events;

architecture Behavioral of gen_timing_events is

begin

    tpg : entity work.ACMI_tpg
        port map(
            clk      => clk, 
            reset    => reset, 
            trig     => trig, 
            params   =>  eeprom_params,
            tp_pos   => tp_pos_pulse, 
            tp_neg   => tp_neg_pulse
        ); 
        
    sample_num : entity work.sampnum
        port map(
            clk => clk,
            trig => trig,
            sampnum => adc_samplenum
        );

end Behavioral;
