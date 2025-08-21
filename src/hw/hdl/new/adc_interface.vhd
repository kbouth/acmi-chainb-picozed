----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 10:25:32 AM
-- Design Name: 
-- Module Name: adc_interface - Behavioral
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
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity adc_interface is
  generic(
    SIM_MODE : integer := 0    
  );
  Port (
      reset : in std_logic;
      trig  : in std_logic;
      sclk  : out std_logic;
      din   : out std_logic;
      dout  : in std_logic; 
      sync  : out std_logic; 
      adc_clk_p : in std_logic; 
      adc_clk_n : in std_logic; 
      adc_data_p: in std_logic_vector(7 downto 0); 
      adc_data_n: in std_logic_vector(7 downto 0); 
      adc_of_p  : in std_logic; 
      adc_of_n  : in std_logic; 
      adc_data_2s: out std_logic_vector(15 downto 0); 
      adc_data_ob: out std_logic_vector(15 downto 0); 
      adc_clk    : out std_logic; 
      adc_sat    : out std_logic
      
  );
end adc_interface;

architecture Behavioral of adc_interface is
    
    signal adc_data         : std_logic_vector(7 downto 0); 
    signal adc_data_sim     : std_logic_vector(15 downto 0); 
    signal adc_of_sync      : std_logic; 
    signal adc_pulse_detect : std_logic;
    
    signal  adc_d1d0        :  std_logic;
    signal  adc_d3d2        :  std_logic;
    signal  adc_d5d4        :  std_logic;
    signal  adc_d7d6        :  std_logic;
    signal  adc_d9d8        :  std_logic;
    signal  adc_d11d10      :  std_logic;
    signal  adc_d13d12      :  std_logic;
    signal  adc_d15d14      :  std_logic;
    signal sample_cnt   : integer := 0;
    
    signal addr       : integer range 0 to 15999 := 0;
    signal triggered  : std_logic := '0';
    signal rom_data   : std_logic_vector(15 downto 0);
    
COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    addra : IN std_logic_vector(13 downto 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;
    
begin



    adc_sat <= adc_of_sync; 
    adc_overflow: IBUFDS
        port map(
            O => adc_of_sync,
            I => adc_of_p,
            IB => adc_of_n        
        ); 
  
    
    adc_clk_200: IBUFDS 
        port map(
            O => adc_clk,
            I => adc_clk_p,
            IB => adc_clk_n
        );
       
 adc_real: if(SIM_MODE = 0) generate
 
     gen_adcdata: for i in 0 to 7 generate
    begin
      adc_data_inst  : IBUFDS  port map (O => adc_data(i), I => adc_data_p(i), IB => adc_data_n(i)); 
    end generate;
   
    adc_readout: entity work.adc_readout_test
    port map(
    reset => reset,
    sys_clk => adc_clk,
    adc_d1d0 => adc_data(0),
    adc_d3d2 => adc_data(1),
    adc_d5d4 => adc_data(2),
    adc_d7d6 => adc_data(3),
    adc_d9d8 => adc_data(4),
    adc_d11d10 => adc_data(5),
    adc_d13d12 => adc_data(6),
    adc_d15d14 => adc_data(7),
    adc_sdo => dout,
    adc_sdi => din,
    adc_sclk => sclk,
    adc_csb => sync,
    data_in => x"0301",
    adc_data_out => adc_data_ob,
    pulse_detect => adc_pulse_detect,
    adc_data_2s => adc_data_2s
    );
    
 end generate; 
 
 adc_debug: if(SIM_MODE = 1) generate read_adc_data:
    
    process(adc_clk)
    begin
        if rising_edge(adc_clk) then
            if trig = '1' then
                triggered <= '1';
                addr <= 0;
            elsif triggered = '1' then
                if addr < 15999 then
                    addr <= addr + 1;
                else
                    triggered <= '0';  -- stop after reading all samples
                end if;
            end if;
        end if;
    end process;
    
    adc_file : blk_mem_gen_0
      PORT MAP (
        clka => adc_clk,
        addra => std_logic_vector(to_unsigned(addr,14)),
        douta => adc_data_sim
      );
  
    process(adc_clk)
    begin
      if (rising_edge(adc_clk)) then
        adc_data_ob <= x"8000" xor adc_data_sim; 
        adc_data_2s <= adc_data_sim;
      end if;
    end process;
    
 
     
     
 end generate; 


end Behavioral;
