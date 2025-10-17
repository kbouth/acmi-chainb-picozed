----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2025 03:41:44 PM
-- Design Name: 
-- Module Name: tx_kria_data - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_kria_data is
  generic (
    FPGA_VERSION : integer
  );
  Port ( 
       clk                  : in std_logic;
       reset                : in std_logic;
       adc_data             : in std_logic_vector(15 downto 0);
       trig                 : in std_logic;
--       startup_cnt          : in std_logic_vector(31 downto 0);
--       acis_readbacks       : in std_logic_vector(7 downto 0);
--       beam_cycle_window    : in std_logic;
       pulse_stats          : in pulse_stats_array;
       eeprom_params        : in eeprom_parameters_type;
--       i2c_regs             : in i2c_regs_type;
--       faults_rdbk          : in std_logic_vector(15 downto 0);
--       faults_lat           : in std_logic_vector(15 downto 0);
--       timestamp            : in std_logic_vector(31 downto 0);
--       accum                : in std_logic_vector(31 downto 0);
--       charge_oow           : out std_logic_vector(31 downto 0);
       tx_data              : out std_logic_vector(31 downto 0);
       tx_data_enb          : out std_logic            
  );
end tx_kria_data;

architecture Behavioral of tx_kria_data is

    
    COMPONENT adc_fifo
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC 
      );
    END COMPONENT;
    
    signal empty, full : std_logic; 
    signal wr_en, rd_en: std_logic; 
    signal adc_data_in, tx_data_out : std_logic_vector(31 downto 0);
    
    type state is (IDLE, BEAM_WINDOW,SEND_RESULTS,SEND_SETTINGS,READ_FIFO);

    signal present_state : state := IDLE; 
    signal count : integer:= 0; 
    signal start : std_logic:= '0'; 
    signal beamoow_stats           : pulse_stats_type;
    signal faults_rdbk_tp          : std_logic_vector(31 downto 0);
    signal tx_data_dly             : std_logic_vector(31 downto 0):= 32d"0"; 
    
    
    signal beamoow_fifodout        : std_logic_vector(15 downto 0);
    signal beamoow_fiforden        : std_logic;
    signal beamoow_found           : std_logic;
    signal beamoow_fiforst         : std_logic;
    
    attribute mark_debug                 : string;
    attribute mark_debug of tx_data: signal is "true";
    attribute mark_debug of present_state: signal is "true";
    attribute mark_debug of count: signal is "true";
    attribute mark_debug of tx_data_enb: signal is "true";
    attribute mark_debug of start: signal is "true";
    
begin
    
    start <= trig; 
    
  
    raw_adc_fifo : adc_fifo
      PORT MAP (
        clk => clk,
        srst => trig,
        din => std_logic_vector(resize(signed(adc_data), 32)),
        wr_en => wr_en,
        rd_en => rd_en,
        dout => tx_data_out,
        full => full,
        empty => empty
      );
      

    fsm: process(clk) begin 
        if(rising_edge(clk)) then 
        if(reset = '1') then 
                wr_en <= '0'; 
                rd_en <= '0'; 
                tx_data_enb <= '0'; 
                count <= 0; 
            else 
--                tx_data <= tx_data_dly;
                
                case present_state is
                    when IDLE =>
                        wr_en <= '0';
                        rd_en <= '0';
                        tx_data_enb <= '0';
                        tx_data <= (others => '0'); 
                        count <= 0;
                        if (start = '1') then -- when triggered by trig, start fsm and send results to backend
                            present_state <= BEAM_WINDOW;
                        end if;
                    
                    when BEAM_WINDOW => -- wait until all calc of all four pulses are done. all four pulses should be within this window of 16000 points
                        tx_data <= (others => '0');
                        if(count < 16100) then 
                            count <= count + 1;
                            wr_en <= '1'; 
                        else
                            count <= 0; 
                            wr_en <= '0';
                            present_state <= SEND_RESULTS; 
                        end if; 
               
                
                    when SEND_RESULTS =>
                        tx_data_enb <= '1';
--                        tx_data <= (others => '0');  -- default to zero
                        
                        if (count = 63) then 
                             count <= 0; 
                             present_state <= SEND_SETTINGS;
                        else 
                            count <= count + 1;
                        end if; 
             
                        case count is
                             --header
                             when 0   =>  tx_data   <= x"0000beef";
                             when 1   =>  tx_data   <= std_logic_vector(to_unsigned(FPGA_VERSION,32)); 
                             -- beam pulse stats
                             when 2   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(0).baseline),32));
                             when 3   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(0).peak),32));
                             when 4   =>  tx_data   <= pulse_stats(0).integral;
                             when 5   =>  tx_data   <= std_logic_vector(resize(unsigned(pulse_stats(0).fwhm),32));  
                             when 6   =>  tx_data   <= pulse_stats(0).peak_index; 
                             -- TP1 stats
--                             when 7   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(1).baseline),32));
--                             when 8   =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(1).peak),32));
--                             when 9   =>  tx_data   <= pulse_stats(1).integral;
--                             when 10  =>  tx_data   <= std_logic_vector(resize(unsigned(pulse_stats(1).fwhm),32));  
--                             when 11  =>  tx_data   <= pulse_stats(1).peak_index;                              
--                             -- TP2 stats
--                             when 12  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(2).baseline),32));
--                             when 13  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(2).peak),32));
--                             when 14  =>  tx_data   <= pulse_stats(2).integral;
--                             when 15  =>  tx_data   <= std_logic_vector(resize(unsigned(pulse_stats(2).fwhm),32));  
--                             when 16  =>  tx_data   <= pulse_stats(2).peak_index;                                              
--                             -- TP3 stats
--                             when 17  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(3).baseline),32));
--                             when 18  =>  tx_data   <= std_logic_vector(resize(signed(pulse_stats(3).peak),32));
--                             when 19  =>  tx_data   <= pulse_stats(3).integral;
--                             when 20  =>  tx_data   <= std_logic_vector(resize(unsigned(pulse_stats(3).fwhm),32));  
--                             when 21  =>  tx_data   <= pulse_stats(3).peak_index; 
--                             -- Beam out of Window stats
--                             when 22  =>  tx_data   <= std_logic_vector(resize(signed(beamoow_stats.baseline),32));
--                             when 23  =>  tx_data   <= std_logic_vector(resize(signed(beamoow_stats.peak),32));
--                             when 24  =>  tx_data   <= beamoow_stats.integral;
--                             when 25  =>  tx_data   <= std_logic_vector(resize(unsigned(beamoow_stats.fwhm),32));   
--                             when 26  =>  tx_data   <= beamoow_stats.peak_index;                           
                             -- faults
--                             when 27  =>  tx_data   <= std_logic_vector(resize(unsigned(faults_rdbk),32));
--                             when 28  =>  tx_data   <= std_logic_vector(resize(unsigned(faults_lat),32));               
--                             --timestamp
--                             when 29  =>  tx_data   <= timestamp;
--                             --accumulator
--                             when 30  =>  tx_data   <= accum;
--                             -- acis readbacks
--                             when 31  =>  tx_data   <= std_logic_vector(resize(unsigned(acis_readbacks),32));
                             --CRC calculated
--                             when 32  =>  tx_data   <= eeprom_params.crc32_calc;
--                             --tp faults readback
--                             when 33  =>  tx_data   <= faults_rdbk_tp;
--                             -- counter since power up
--                             when 34  =>  tx_data   <= 32d"0";--startup_cnt;
--                             -- beamaccum limit
--                             when 35  =>  tx_data   <= 32d"0"; --eeprom_params.beamaccum_limit_calc;           
--                             --reserved placeholder
--                             when 36   =>  tx_data   <= 32d"0";
--                             when 37   =>  tx_data   <= 32d"0";
--                             when 38   =>  tx_data   <= 32d"0";             
--                             when 39   =>  tx_data   <= 32d"0";            
--                             when 40   =>  tx_data   <= std_logic_vector(resize(unsigned(i2c_regs.temp0),32));
--                             when 41   =>  tx_data   <= std_logic_vector(resize(unsigned(i2c_regs.temp1),32)); 
--                             when 42   =>  tx_data   <= std_logic_vector(resize(unsigned(i2c_regs.vreg0),32));
--                             when 43   =>  tx_data   <= std_logic_vector(resize(unsigned(i2c_regs.ireg0),32));            
                             
--                             when 44 to 62 => tx_data <= 32d"0";
                             when 63 => tx_data    <= x"deadbeef";
                            when others => null;
                        end case;
                
                    when SEND_SETTINGS =>
                        
                        tx_data_enb <= '1';
--                        tx_data <= (others => '0');  -- default to zero
                        if (count = 63) then 
                             count <= 0; 
                             present_state <= READ_FIFO;
                        else 
                            count <= count + 1;
                        end if; 
      
                        case count is
                             when 0   =>  tx_data   <= eeprom_params.header;           
--                             when 1   =>  tx_data   <= eeprom_params.tp1_pulse_delay; 
--                             when 2  =>  tx_data   <= eeprom_params.tp1_pulse_width;     
--                             when 3  =>  tx_data   <= eeprom_params.tp1_adc_delay;     
--                             when 4   =>  tx_data   <= eeprom_params.tp2_pulse_delay; 
--                             when 5   =>  tx_data   <= eeprom_params.tp2_pulse_width;     
--                             when 6  =>  tx_data   <= eeprom_params.tp2_adc_delay;                 
--                             when 7  =>  tx_data   <= eeprom_params.tp3_pulse_delay; 
--                             when 8  =>  tx_data   <= eeprom_params.tp3_pulse_width;    
--                             when 9  =>  tx_data   <= eeprom_params.tp3_adc_delay;                  
                             when 10  =>  tx_data   <= eeprom_params.beam_adc_delay; 
--                             when 11  =>  tx_data   <= std_logic_vector(resize(signed(eeprom_params.beam_oow_threshold),32));  
--                             when 12  =>  tx_data   <= eeprom_params.tp1_int_low_limit; 
--                             when 13  =>  tx_data   <= eeprom_params.tp1_int_high_limit;           
--                             when 14  =>  tx_data   <= eeprom_params.tp2_int_low_limit;
--                             when 15  =>  tx_data   <= eeprom_params.tp2_int_high_limit;      
--                             when 16  =>  tx_data   <= eeprom_params.tp3_int_low_limit;
--                             when 17  =>  tx_data   <= eeprom_params.tp3_int_high_limit;                                  
--                             when 18  =>  tx_data   <= eeprom_params.tp1_peak_low_limit;
--                             when 19  =>  tx_data   <= eeprom_params.tp1_peak_high_limit;
--                             when 20  =>  tx_data   <= eeprom_params.tp2_peak_low_limit;
--                             when 21  =>  tx_data   <= eeprom_params.tp2_peak_high_limit;         
--                             when 22  =>  tx_data   <= eeprom_params.tp3_peak_low_limit;
--                             when 23  =>  tx_data   <= eeprom_params.tp3_peak_high_limit;                                 
--                             when 24  =>  tx_data   <= eeprom_params.tp1_fwhm_low_limit;
--                             when 25  =>  tx_data   <= eeprom_params.tp1_fwhm_high_limit;         
--                             when 26  =>  tx_data   <= eeprom_params.tp2_fwhm_low_limit;
--                             when 27  =>  tx_data   <= eeprom_params.tp2_fwhm_high_limit;        
--                             when 28  =>  tx_data   <= eeprom_params.tp3_fwhm_low_limit;
--                             when 29  =>  tx_data   <= eeprom_params.tp3_fwhm_high_limit;      
--                             when 30  =>  tx_data   <= eeprom_params.tp1_base_low_limit;                 
--                             when 31  =>  tx_data   <= eeprom_params.tp1_base_high_limit;       
--                             when 32  =>  tx_data   <= eeprom_params.tp2_base_low_limit;      
--                             when 33  =>  tx_data   <= eeprom_params.tp2_base_high_limit;     
--                             when 34  =>  tx_data   <= eeprom_params.tp3_base_low_limit;
--                             when 35  =>  tx_data   <= eeprom_params.tp3_base_high_limit;
--                             when 36  =>  tx_data   <= eeprom_params.tp1_pos_level;
--                             when 37  =>  tx_data   <= eeprom_params.tp2_pos_level;
--                             when 38  =>  tx_data   <= eeprom_params.tp3_pos_level;
--                             when 39  =>  tx_data   <= eeprom_params.tp1_neg_level;
--                             when 40  =>  tx_data   <= eeprom_params.tp2_neg_level;  
--                             when 41  =>  tx_data   <= eeprom_params.tp3_neg_level;                              
--                             when 42  =>  tx_data   <= eeprom_params.beamaccum_limit_hr;
--                             when 43  =>  tx_data   <= eeprom_params.beamhigh_limit;
--                             when 44  =>  tx_data   <= eeprom_params.baseline_low_limit;
--                             when 45  =>  tx_data   <= eeprom_params.baseline_high_limit;
--                             when 46  =>  tx_data   <= eeprom_params.charge_calibration;
--                             when 47  =>  tx_data   <= eeprom_params.accum_q_min;
--                             when 48  =>  tx_data   <= eeprom_params.accum_length;                      
--                             when 49  =>  tx_data   <= eeprom_params.crc32_eeprom;  
--                             when 50 to 61 =>  tx_data   <= 32d"0";          
--                             when 62 =>   tx_data <= 32d"0";
--                             when 63 =>   tx_data <= 32d"0";
                             when others => null;
                     
                        end case;
                      
                        
                    when READ_FIFO =>
                        if (count < 16000) then
                            rd_en <= '1';
                            tx_data <= tx_data_out;
                            count <= count + 1;
                        else
                            rd_en <= '0';
                            count <= 0;
                            present_state <= IDLE;
                        end if;
                    
                    when others => present_state <= IDLE; 
                end case;
            end if;
            end if;  
    end process; 

    
    
end Behavioral;
