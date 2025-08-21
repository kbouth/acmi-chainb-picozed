----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/20/2025 10:32:30 AM
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
library work;
use work.acmi_package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ACMI_tpg is
  Port ( 
    clk      : in std_logic; 
    reset    : in std_logic; 
    trig     : in std_logic; 
    params   : in eeprom_parameters_type; 
    tp_pos   : out std_logic_vector(4 downto 0); 
    tp_neg   : out std_logic_vector(4 downto 0)
  );
end ACMI_tpg;

architecture Behavioral of ACMI_tpg is
    
    signal tp1,tp2, tp3 : std_logic:= '0'; 
    
    COMPONENT tpg_ila
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC; 
        probe1 : IN STD_LOGIC; 
        probe2 : IN STD_LOGIC; 
        probe3 : IN STD_LOGIC; 
        probe4 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe6 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe7 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe8 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe9 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe10 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe11 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
        probe12 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe13 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe14 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe15 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe16 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe17 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT  ;
    
begin

--    tpg_debug : tpg_ila
--    PORT MAP (
--        clk => clk,
--        probe0 => '0', 
--        probe1 => tp1, 
--        probe2 => tp2, 
--        probe3 => tp3, 
--        probe4 => tp_pos, 
--        probe5 => tp_neg, 
--        probe6 => params.tp1_pos_level(4 downto 0), 
--        probe7 => params.tp2_pos_level(4 downto 0), 
--        probe8 => params.tp3_pos_level(4 downto 0), 
--        probe9 => params.tp1_neg_level(4 downto 0), 
--        probe10 => params.tp2_neg_level(4 downto 0), 
--        probe11 => params.tp3_neg_level(4 downto 0), 
--        probe12 => params.tp1_pulse_delay, 
--        probe13 => params.tp2_pulse_delay, 
--        probe14 => params.tp3_pulse_delay, 
--        probe15 => params.tp1_pulse_width, 
--        probe16 => params.tp2_pulse_width,
--        probe17 => params.tp3_pulse_width
--    );


    tp_pos <= params.tp1_pos_level(4 downto 0) when tp1 = '1' else
              params.tp2_pos_level(4 downto 0) when tp2 = '1' else
              params.tp3_pos_level(4 downto 0) when tp3 = '1' else
              "00000"; 

    tp_neg <= params.tp1_neg_level(4 downto 0) when tp1 = '1' else
              params.tp2_neg_level(4 downto 0) when tp2 = '1' else
              params.tp3_neg_level(4 downto 0) when tp3 = '1' else
              "00000"; 
    
    tp1_pulse: entity work.pulse_gen
        port map(
            sys_clk => clk,
            reset => reset,
            event_trig => trig,
            tp_delay => params.tp1_pulse_delay,
            tp_width => params.tp1_pulse_width,
            pulse => tp1
        ); 
    
    tp2_pulse: entity work.pulse_gen
        port map(
            sys_clk => clk,
            reset => reset,
            event_trig => trig,
            tp_delay => params.tp2_pulse_delay,
            tp_width => params.tp2_pulse_width,
            pulse => tp2
        ); 
        
    tp3_pulse: entity work.pulse_gen
        port map(
            sys_clk => clk,
            reset => reset,
            event_trig => trig,
            tp_delay => params.tp3_pulse_delay,
            tp_width => params.tp3_pulse_width,
            pulse => tp3
        ); 

end Behavioral;
