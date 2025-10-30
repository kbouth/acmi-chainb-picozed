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
       accum                : in std_logic_vector(31 downto 0);
--       charge_oow           : out std_logic_vector(31 downto 0);
       tx_clk               : out std_logic; 
       tx_data              : out std_logic_vector(15 downto 0);
       tx_data_enb          : out std_logic            
  );
end tx_kria_data;

architecture Behavioral of tx_kria_data is

    
    COMPONENT adc_fifo
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC 
      );
    END COMPONENT;
    
    signal empty, full : std_logic; 
    signal wr_en, rd_en: std_logic; 
    signal adc_data_in, tx_data_out : std_logic_vector(15 downto 0);
    
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
    tx_clk <= clk; 
  
    raw_adc_fifo : adc_fifo
      PORT MAP (
        clk => clk,
        srst => trig,
        din => adc_data,
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
                        
                        if (count = 127) then 
                             count <= 0; 
                             present_state <= SEND_SETTINGS;
                        else 
                            count <= count + 1;
                        end if; 
             
                        case count is
                             --header
                             when 0   =>  tx_data   <= x"0000";
                             when 1  =>   tx_data   <= x"beef";
                             
                             when 2  =>   tx_data   <= x"0000"; 
                             when 3   =>  tx_data   <= std_logic_vector(to_unsigned(FPGA_VERSION,16)); 
                             -- beam pulse stats
                             when 4   =>  tx_data   <= (others => pulse_stats(0).baseline(15));
                             when 5   =>  tx_data   <= pulse_stats(0).baseline; 
                             
                             when 6   =>  tx_data   <= (others => pulse_stats(0).peak(16));
                             when 7   =>  tx_data   <= pulse_stats(0).peak(15 downto 0);  
                             
                             when 8   =>  tx_data   <= pulse_stats(0).integral(31 downto 16);
                             when 9   =>  tx_data   <= pulse_stats(0).integral(15 downto 0); 
                             
                             when 10   =>  tx_data   <= x"0000";
                             when 11   =>  tx_data   <= pulse_stats(0).fwhm; 
                               
                             when 12   =>  tx_data   <= pulse_stats(0).peak_index(31 downto 16);
                             when 13   =>  tx_data   <= pulse_stats(0).peak_index(15 downto 0);  
                             -- TP1 stats
                             when 14   =>  tx_data   <= (others => pulse_stats(1).baseline(15));
                             when 15   =>  tx_data   <= pulse_stats(1).baseline; 
                             
                             when 16   =>  tx_data   <= (others => pulse_stats(1).peak(16));
                             when 17   =>  tx_data   <= pulse_stats(1).peak(15 downto 0);  
                             
                             when 18   =>  tx_data   <= pulse_stats(1).integral(31 downto 16);
                             when 19   =>  tx_data   <= pulse_stats(1).integral(15 downto 0); 
                             
                             when 20   =>  tx_data   <= x"0000";
                             when 21   =>  tx_data   <= pulse_stats(1).fwhm; 
                               
                             when 22   =>  tx_data   <= pulse_stats(1).peak_index(31 downto 16);
                             when 23   =>  tx_data   <= pulse_stats(1).peak_index(15 downto 0);                              
                             -- TP2 stats
                             when 24   =>  tx_data   <= (others => pulse_stats(2).baseline(15));
                             when 25   =>  tx_data   <= pulse_stats(2).baseline; 
                             
                             when 26   =>  tx_data   <= (others => pulse_stats(2).peak(16));
                             when 27   =>  tx_data   <= pulse_stats(2).peak(15 downto 0);  
                             
                             when 28   =>  tx_data   <= pulse_stats(2).integral(31 downto 16);
                             when 29   =>  tx_data   <= pulse_stats(2).integral(15 downto 0); 
                             
                             when 30   =>  tx_data   <= x"0000";
                             when 31   =>  tx_data   <= pulse_stats(2).fwhm; 
                               
                             when 32   =>  tx_data   <= pulse_stats(2).peak_index(31 downto 16);
                             when 33   =>  tx_data   <= pulse_stats(2).peak_index(15 downto 0);                                              
                             -- TP3 stats
                             when 34   =>  tx_data   <= (others => pulse_stats(3).baseline(15));
                             when 35   =>  tx_data   <= pulse_stats(3).baseline; 
                             
                             when 36   =>  tx_data   <= (others => pulse_stats(3).peak(16));
                             when 37   =>  tx_data   <= pulse_stats(3).peak(15 downto 0);  
                             
                             when 38   =>  tx_data   <= pulse_stats(3).integral(31 downto 16);
                             when 39   =>  tx_data   <= pulse_stats(3).integral(15 downto 0); 
                             
                             when 40   =>  tx_data   <= x"0000";
                             when 41   =>  tx_data   <= pulse_stats(3).fwhm; 
                               
                             when 42   =>  tx_data   <= pulse_stats(3).peak_index(31 downto 16);
                             when 43   =>  tx_data   <= pulse_stats(3).peak_index(15 downto 0); 
                             -- Beam out of Window stats
                             when 44   =>  tx_data   <= (others => beamoow_stats.baseline(15));
                             when 45   =>  tx_data   <= beamoow_stats.baseline; 
                             
                             when 46   =>  tx_data   <= (others => beamoow_stats.peak(16));
                             when 47   =>  tx_data   <= beamoow_stats.peak(15 downto 0);  
                             
                             when 48   =>  tx_data   <= beamoow_stats.integral(31 downto 16);
                             when 49   =>  tx_data   <= beamoow_stats.integral(15 downto 0); 
                             
                             when 50   =>  tx_data   <= x"0000";
                             when 51   =>  tx_data   <= beamoow_stats.fwhm; 
                               
                             when 52   =>  tx_data   <= beamoow_stats.peak_index(31 downto 16);
                             when 53   =>  tx_data   <= beamoow_stats.peak_index(15 downto 0);                           
                             -- faults
                             when 54  =>  tx_data   <= x"0000";
--                             when 55  =>  tx_data   <= faults_rdbk;              
                             when 56  =>  tx_data   <= x"0000";
--                             when 57  =>  tx_data   <= faults_lat;
                             --timestamp
--                             when 58  =>  tx_data   <= timestamp(31 downto 16);
--                             when 59  =>  tx_data   <= timestamp(15 downto 0);
                             --accumulator
                             when 60  =>  tx_data   <= accum(31 downto 16);
                             when 61  =>  tx_data   <= accum(15 downto 0);
                             -- acis readbacks
                             when 62  =>  tx_data   <= x"0000";  
--                             when 63  =>  tx_data   <= x"00" & acis_readbacks;
                             --CRC calculated
--                             when 64  =>  tx_data   <= eeprom_params.crc32_calc(31 downto 16);
--                             when 65  =>  tx_data   <= eeprom_params.crc32_calc(15 downto 0);
                             --tp faults readback
--                             when 66  =>  tx_data   <= faults_rdbk_tp(31 downto 16);
--                             when 67  =>  tx_data   <= faults_rdbk_tp(15 downto 0); 
                 
--                             when 68  =>  tx_data   <= startup_cnt(31 downto 16);
--                             when 69  =>  tx_data   <= startup_cnt(15 downto 0);  
                                      
                             --reserved placeholder
                             when 70 to 125 => tx_data <= x"0000"; --std_logic_vector(to_unsigned(words_written,16)); 
                             when 126 => tx_data    <= x"dead";
                             when 127 => tx_data    <= x"beef";
                            when others => null;
                        end case;
                
                    when SEND_SETTINGS =>
                        
                        tx_data_enb <= '1';
--                        tx_data <= (others => '0');  -- default to zero
                        if (count = 127) then 
                             count <= 0; 
                             present_state <= READ_FIFO;
                        else 
                            count <= count + 1;
                        end if; 
      
                        case count is
                             when 0   =>  tx_data   <= eeprom_params.header(31 downto 16);
                             when 1   =>  tx_data   <= eeprom_params.header(15 downto 0);
                             
                             when 2   =>  tx_data   <= eeprom_params.tp1_pulse_delay(31 downto 16); 
                             when 3   =>  tx_data   <= eeprom_params.tp1_pulse_delay(15 downto 0);
                             
                             when 4   =>  tx_data   <= eeprom_params.tp1_pulse_width(31 downto 16);
                             when 5   =>  tx_data   <= eeprom_params.tp1_pulse_width(15 downto 0);  
                                      
                             when 6  =>  tx_data   <= eeprom_params.tp1_adc_delay(31 downto 16);
                             when 7  =>  tx_data   <= eeprom_params.tp1_adc_delay(15 downto 0);                          
                             
                             when 8  =>  tx_data   <= eeprom_params.tp2_pulse_delay(31 downto 16); 
                             when 9  =>  tx_data   <= eeprom_params.tp2_pulse_delay(15 downto 0);
                             
                             when 10  =>  tx_data   <= eeprom_params.tp2_pulse_width(31 downto 16);
                             when 11  =>  tx_data   <= eeprom_params.tp2_pulse_width(15 downto 0);     
                             
                             when 12  =>  tx_data   <= eeprom_params.tp2_adc_delay(31 downto 16); 
                             when 13  =>  tx_data   <= eeprom_params.tp2_adc_delay(15 downto 0);              
                             
                             when 14  =>  tx_data   <= eeprom_params.tp3_pulse_delay(31 downto 16); 
                             when 15  =>  tx_data   <= eeprom_params.tp3_pulse_delay(15 downto 0);
                             
                             when 16  =>  tx_data   <= eeprom_params.tp3_pulse_width(31 downto 16);
                             when 17  =>  tx_data   <= eeprom_params.tp3_pulse_width(15 downto 0);
                             
                             when 18  =>  tx_data   <= eeprom_params.tp3_adc_delay(31 downto 16);
                             when 19  =>  tx_data   <= eeprom_params.tp3_adc_delay(15 downto 0);           
                             
                             when 20  =>  tx_data   <= eeprom_params.beam_adc_delay(31 downto 16); 
                             when 21  =>  tx_data   <= eeprom_params.beam_adc_delay(15 downto 0);                            
                             
                             when 22  =>  tx_data   <= (others => eeprom_params.beam_oow_threshold(15));
                             when 23  =>  tx_data   <= eeprom_params.beam_oow_threshold(15 downto 0);         
                             
                             when 24  =>  tx_data   <= eeprom_params.tp1_int_low_limit(31 downto 16);
                             when 25  =>  tx_data   <= eeprom_params.tp1_int_low_limit(15 downto 0);    
                             
                             when 26  =>  tx_data   <= eeprom_params.tp1_int_high_limit(31 downto 16);
                             when 27  =>  tx_data   <= eeprom_params.tp1_int_high_limit(15 downto 0);                 
                             
                             when 28  =>  tx_data   <= eeprom_params.tp2_int_low_limit(31 downto 16);
                             when 29  =>  tx_data   <= eeprom_params.tp2_int_low_limit(15 downto 0);    
                             
                             when 30  =>  tx_data   <= eeprom_params.tp2_int_high_limit(31 downto 16);
                             when 31  =>  tx_data   <= eeprom_params.tp2_int_high_limit(15 downto 0);                 
                             
                             when 32  =>  tx_data   <= eeprom_params.tp3_int_low_limit(31 downto 16);
                             when 33  =>  tx_data   <= eeprom_params.tp3_int_low_limit(15 downto 0);    
                             
                             when 34  =>  tx_data   <= eeprom_params.tp3_int_high_limit(31 downto 16);
                             when 35  =>  tx_data   <= eeprom_params.tp3_int_high_limit(15 downto 0);                                               
                             
                             when 36  =>  tx_data   <= eeprom_params.tp1_peak_low_limit(31 downto 16);
                             when 37  =>  tx_data   <= eeprom_params.tp1_peak_low_limit(15 downto 0);    
                             
                             when 38  =>  tx_data   <= eeprom_params.tp1_peak_high_limit(31 downto 16);
                             when 39  =>  tx_data   <= eeprom_params.tp1_peak_high_limit(15 downto 0);                 
                             
                             when 40  =>  tx_data   <= eeprom_params.tp2_peak_low_limit(31 downto 16);
                             when 41  =>  tx_data   <= eeprom_params.tp2_peak_low_limit(15 downto 0);    
                             
                             when 42  =>  tx_data   <= eeprom_params.tp2_peak_high_limit(31 downto 16);
                             when 43  =>  tx_data   <= eeprom_params.tp2_peak_high_limit(15 downto 0);                 
                             
                             when 44  =>  tx_data   <= eeprom_params.tp3_peak_low_limit(31 downto 16);
                             when 45  =>  tx_data   <= eeprom_params.tp3_peak_low_limit(15 downto 0);    
                             
                             when 46  =>  tx_data   <= eeprom_params.tp3_peak_high_limit(31 downto 16);
                             when 47  =>  tx_data   <= eeprom_params.tp3_peak_high_limit(15 downto 0);                                        
                             
                             when 48  =>  tx_data   <= eeprom_params.tp1_peak_low_limit(31 downto 16);
                             when 49  =>  tx_data   <= eeprom_params.tp1_fwhm_low_limit(15 downto 0);    
                             
                             when 50  =>  tx_data   <= eeprom_params.tp1_fwhm_high_limit(31 downto 16);
                             when 51  =>  tx_data   <= eeprom_params.tp1_fwhm_high_limit(15 downto 0);                 
                             
                             when 52  =>  tx_data   <= eeprom_params.tp2_fwhm_low_limit(31 downto 16);
                             when 53  =>  tx_data   <= eeprom_params.tp2_fwhm_low_limit(15 downto 0);    
                             
                             when 54  =>  tx_data   <= eeprom_params.tp2_fwhm_high_limit(31 downto 16);
                             when 55  =>  tx_data   <= eeprom_params.tp2_fwhm_high_limit(15 downto 0);                 
                             
                             when 56  =>  tx_data   <= eeprom_params.tp3_fwhm_low_limit(31 downto 16);
                             when 57  =>  tx_data   <= eeprom_params.tp3_fwhm_low_limit(15 downto 0);    
                             
                             when 58  =>  tx_data   <= eeprom_params.tp3_fwhm_high_limit(31 downto 16);
                             when 59  =>  tx_data   <= eeprom_params.tp3_fwhm_high_limit(15 downto 0);                 
                             
                             when 60  =>  tx_data   <= eeprom_params.tp1_base_low_limit(31 downto 16);         
                             when 61  =>  tx_data   <= eeprom_params.tp1_base_low_limit(15 downto 0);    
                             
                             when 62  =>  tx_data   <= eeprom_params.tp1_base_high_limit(31 downto 16);
                             when 63  =>  tx_data   <= eeprom_params.tp1_base_high_limit(15 downto 0);                 
                             
                             when 64  =>  tx_data   <= eeprom_params.tp2_base_low_limit(31 downto 16);
                             when 65  =>  tx_data   <= eeprom_params.tp2_base_low_limit(15 downto 0);    
                             
                             when 66  =>  tx_data   <= eeprom_params.tp2_base_high_limit(31 downto 16);
                             when 67  =>  tx_data   <= eeprom_params.tp2_base_high_limit(15 downto 0);                 
                             
                             when 68  =>  tx_data   <= eeprom_params.tp3_base_low_limit(31 downto 16);
                             when 69  =>  tx_data   <= eeprom_params.tp3_base_low_limit(15 downto 0);    
                             
                             when 70  =>  tx_data   <= eeprom_params.tp3_base_high_limit(31 downto 16);
                             when 71  =>  tx_data   <= eeprom_params.tp3_base_high_limit(15 downto 0);   
                             
                             when 72  =>  tx_data   <= eeprom_params.tp1_pos_level(31 downto 16);
                             when 73  =>  tx_data   <= eeprom_params.tp1_pos_level(15 downto 0);   
                             
                             when 74  =>  tx_data   <= eeprom_params.tp2_pos_level(31 downto 16);
                             when 75  =>  tx_data   <= eeprom_params.tp2_pos_level(15 downto 0);   
                             
                             when 76  =>  tx_data   <= eeprom_params.tp3_pos_level(31 downto 16);
                             when 77  =>  tx_data   <= eeprom_params.tp3_pos_level(15 downto 0);              
                             
                             when 78  =>  tx_data   <= eeprom_params.tp1_neg_level(31 downto 16);
                             when 79  =>  tx_data   <= eeprom_params.tp1_neg_level(15 downto 0);   
                             
                             when 80  =>  tx_data   <= eeprom_params.tp2_neg_level(31 downto 16);
                             when 81  =>  tx_data   <= eeprom_params.tp2_neg_level(15 downto 0);   
                             
                             when 82  =>  tx_data   <= eeprom_params.tp3_neg_level(31 downto 16);
                             when 83  =>  tx_data   <= eeprom_params.tp3_neg_level(15 downto 0);                                                             
                             
                             when 84  =>  tx_data   <= eeprom_params.beamaccum_limit_hr(31 downto 16);
                             when 85  =>  tx_data   <= eeprom_params.beamaccum_limit_hr(15 downto 0);         
                             
                             when 86  =>  tx_data   <= eeprom_params.beamhigh_limit(31 downto 16);
                             when 87  =>  tx_data   <= eeprom_params.beamhigh_limit(15 downto 0);         
                             
                             when 88  =>  tx_data   <= eeprom_params.baseline_low_limit(31 downto 16);
                             when 89  =>  tx_data   <= eeprom_params.baseline_low_limit(15 downto 0);         
                             
                             when 90  =>  tx_data   <= eeprom_params.baseline_high_limit(31 downto 16);
                             when 91  =>  tx_data   <= eeprom_params.baseline_high_limit(15 downto 0);  
                             
                             when 92 =>  tx_data   <= eeprom_params.charge_calibration(31 downto 16);
                             when 93 =>  tx_data   <= eeprom_params.charge_calibration(15 downto 0); 
                             
                             when 94 =>  tx_data   <= eeprom_params.accum_q_min(31 downto 16);
                             when 95 =>  tx_data   <= eeprom_params.accum_q_min(15 downto 0);             
                             
                             when 96 =>  tx_data   <= eeprom_params.accum_length(31 downto 16);
                             when 97 =>  tx_data   <= eeprom_params.accum_length(15 downto 0);                                  
                             
                             when 98 =>  tx_data   <= eeprom_params.crc32_eeprom(31 downto 16);
                             when 99 =>  tx_data   <= eeprom_params.crc32_eeprom(15 downto 0);
                                  
                             when 100 to 125   =>  tx_data <= x"0000";
                                         
                             when 126 =>  tx_data <= x"0000";
--                                          beamoow_fiforden <= '1';
                             when 127 =>  tx_data   <= x"0000";
                                          --beamoow_fiforden <= '1';
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
