----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2025 03:21:23 PM
-- Design Name: 
-- Module Name: calc_charge - Behavioral
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

library work;
use work.acmi_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calc_charge is
  Port (
   clk                : in std_logic;
   trig               : in std_logic;
   adc_samplenum      : in std_logic_vector(31 downto 0);
--   test_pulse_gates   : in std_logic_vector(3 downto 0);  
   params             : in eeprom_parameters_type;            
   adc_data       : in std_logic_vector(15 downto 0);
--   adc_data_inv_dly   : out std_logic_vector(15 downto 0);
   pulse_stats        : out pulse_stats_array 
   );
end calc_charge;

architecture Behavioral of calc_charge is
COMPONENT c_shift_ram_0
  PORT (
    D : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLK : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;

-- shift the adc_data by 40 clocks
signal adc_data_dly : STD_LOGIC_VECTOR(15 downto 0); 
begin
  adc_shift : c_shift_ram_0
  PORT MAP (
    D => adc_data,
    CLK => clk,
    Q => adc_data_dly
  );
  
-- beam 
beam:  entity work.calc_stats
  port map ( 
   clk => clk, 
   trig => trig,
   adc_data => signed(adc_data),
   adc_data_dly => signed(adc_data_dly), 
   gate_start => params.beam_adc_delay,  
   adc_samplenum => adc_samplenum,
   pulse_stats => pulse_stats(0)
  );      

end Behavioral;
