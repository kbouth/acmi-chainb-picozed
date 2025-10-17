----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2025 04:09:51 PM
-- Design Name: 
-- Module Name: eeprom_interface - Behavioral
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
library work;
use work.acmi_package.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eeprom_interface is
  Port (
        clk           : in std_logic; 
        reset         : in std_logic; 
        pzed_params   : in pzed_parameters_type;
        eeprom_params : out eeprom_parameters_type;
        sclk          : out std_logic; 
        din           : out std_logic; 
        dout          : in std_logic; 
        csn           : out std_logic; 
        holdn         : out std_logic; 
        eeprom_rdy    : out std_logic
   );
end eeprom_interface;

architecture Behavioral of eeprom_interface is

    signal opcode : std_logic_vector(7 downto 0);
    signal address: std_logic_vector(15 downto 0); 
    signal data_in: std_logic_vector(7 downto 0); 
    signal rddata,rddata1,rddata2  : std_logic_vector(7 downto 0); 
    signal trig   : std_logic; 
    
    signal prev_spi_done, spi_done, spi_sync1, spi_sync   : std_logic; 
    signal wr_rd      : std_logic; 
    signal bytes      : integer range 0 to 200; 
    
    signal eeprom_data : eeprom_data_type; 
    type state is (IDLE,SINGLE_TRANS,RD_ALL_EEPROM,WAIT_EEPROM,DONE); 
    
    signal eeprom_state : state:= IDLE; 
    signal prev_csn, csn_sync, csn_sync1     : std_logic; 
    signal beam_adc_delay : std_logic_vector(31 downto 0); 
    
    attribute mark_debug                 : string;
    attribute mark_debug of trig: signal is "true";
--    attribute mark_debug of eeprom_rdy: signal is "true";
    attribute mark_debug of eeprom_state : signal is "true"; 
    attribute mark_debug of opcode : signal is "true"; 
    attribute mark_debug of address: signal is "true"; 
    attribute mark_debug of rddata : signal is "true"; 
    attribute mark_debug of eeprom_params: signal is "true";
    attribute mark_debug of din: signal is "true";
    attribute mark_debug of dout: signal is "true";
    attribute mark_debug of csn: signal is "true";
--    attribute mark_debug of bytes: signal is "true"; 
    
    
begin

    
    sync_spi : process(clk) begin 
        if(rising_edge(clk)) then 
            spi_sync1 <= spi_done;
            spi_sync <= spi_sync1;  
        end if; 
    end process; 
    
    sync_csn : process(clk) begin 
        if(rising_edge(clk)) then 
            csn_sync1 <= csn;
            csn_sync <= csn_sync1;  
        end if; 
    end process; 
    
    eeprom_fsm : process(clk) begin 
        if(rising_edge(clk)) then 
            
            prev_spi_done <= spi_sync; 
            prev_csn <= csn_sync; 
            
            if(reset = '1') then 
                opcode <= (others => '0'); 
                address <= (others => '0'); 
                data_in <= (others => '0'); 
                trig <= '0'; 
                bytes <= 0; 
                eeprom_state <= IDLE; 
            else 
                
                case(eeprom_state) is
                    
                    when IDLE => 
                        trig <= '0'; 
                        eeprom_rdy <= '0'; 
                        if(pzed_params.eeprom_trig = '1') then 
                            eeprom_state <= SINGLE_TRANS; 
                        elsif(pzed_params.eeprom_readall = '1') then 
                            eeprom_state <= RD_ALL_EEPROM; 
                            address <= x"0000";
                            bytes <= 0;
                        else 
                            eeprom_state <= IDLE; 
                        end if; 
                    
                    when SINGLE_TRANS =>
                        trig <= '1'; 
                        opcode <= pzed_params.eeprom_wrdata(31 downto 24);
                        address <= pzed_params.eeprom_wrdata(23 downto 8); 
                        data_in <= pzed_params.eeprom_wrdata(7 downto 0); 
                        if(prev_spi_done = '0' and spi_sync = '1') then 
                            eeprom_state <= DONE;
                        else 
                            eeprom_state <= SINGLE_TRANS; 
                        end if; 
                    
                    when RD_ALL_EEPROM =>
                        trig <= '1'; 
                        opcode <= "00000011";
--                        eeprom_state <= WAIT_EEPROM;
                        if(prev_spi_done = '0' and spi_sync = '1') then
                            eeprom_state <= WAIT_EEPROM; 
                        else
                            eeprom_state <= RD_ALL_EEPROM;
                        end if; 
                        
                    when WAIT_EEPROM => 
                        
                            eeprom_data(bytes) <= rddata; 
                            
                            if(bytes = EEPROM_LEN) then 
                                eeprom_state <= DONE; 
                            else 
                                if(prev_csn = '1' and csn_sync = '0') then 
                                    eeprom_state <= RD_ALL_EEPROM;
                                    address <= address + x"1"; 
                                    bytes <= bytes + 1;
                                else 
                                    eeprom_state <= WAIT_EEPROM; 
                                end if;  
                            end if; 
                    
                    when DONE => 
--                        opcode <= (others => '0');
--                        address <= x"0000";
--                        data_in <= (others => '0'); 
                        bytes <= 0;
                        trig <= '0'; 
                        eeprom_rdy <= '1'; 
                        eeprom_state <= IDLE; 
                    
                end case; 
            end if ;
        end if; 
    end process; 

    eeprom_spi: entity work.eeprom
        port map(
            sys_clk => clk,
            reset  => reset, 
            opcode_in => opcode,
            address => address,
            data_in => data_in,
            n_bytes => "001",
            trig => trig, 
            rddata => rddata1,
            
            ------ EEPROM SPI PORTS ----------
            sdo   => dout,
            csn   => csn,   
            holdn => holdn,
            sclk  => sclk, 
            sdi   => din,
            spi_done => spi_done         
    );
    
    rddata_sync: process(clk) begin 
        if(rising_edge(clk)) then 
            rddata2 <= rddata1; 
            rddata <= rddata2; 
        end if; 
    end process; 
    

    eeprom_synth: process (clk) begin 
      if (rising_edge(clk)) then
        if(reset = '1') then 
            eeprom_params <= (others => (others => '0')); 
        elsif(eeprom_rdy = '1')then 
          eeprom_params.header               <= eeprom_data(0) & eeprom_data(1) & eeprom_data(2) & eeprom_data(3);
          eeprom_params.tp1_pulse_delay      <= eeprom_data(4) & eeprom_data(5) & eeprom_data(6) & eeprom_data(7);
          eeprom_params.tp1_pulse_width      <= eeprom_data(8) & eeprom_data(9) & eeprom_data(10) & eeprom_data(11); 
          eeprom_params.tp1_adc_delay        <= eeprom_data(12) & eeprom_data(13) & eeprom_data(14) & eeprom_data(15);  
          eeprom_params.tp2_pulse_delay      <= eeprom_data(16) & eeprom_data(17) & eeprom_data(18) & eeprom_data(19);
          eeprom_params.tp2_pulse_width      <= eeprom_data(20) & eeprom_data(21) & eeprom_data(22) & eeprom_data(23);
          eeprom_params.tp2_adc_delay        <= eeprom_data(24) & eeprom_data(25) & eeprom_data(26) & eeprom_data(27);   
          eeprom_params.tp3_pulse_delay      <= eeprom_data(28) & eeprom_data(29) & eeprom_data(30) & eeprom_data(31);
          eeprom_params.tp3_pulse_width      <= eeprom_data(32) & eeprom_data(33) & eeprom_data(34) & eeprom_data(35);
          eeprom_params.tp3_adc_delay        <= eeprom_data(36) & eeprom_data(37) & eeprom_data(38) & eeprom_data(39);  
          eeprom_params.beam_adc_delay       <= eeprom_data(40) & eeprom_data(41) & eeprom_data(42) & eeprom_data(43);
          eeprom_params.beam_oow_threshold   <=                                     eeprom_data(46) & eeprom_data(47);
          eeprom_params.tp1_int_low_limit    <= eeprom_data(48) & eeprom_data(49) & eeprom_data(50) & eeprom_data(51);
          eeprom_params.tp1_int_high_limit   <= eeprom_data(52) & eeprom_data(53) & eeprom_data(54) & eeprom_data(55);
          eeprom_params.tp2_int_low_limit    <= eeprom_data(56) & eeprom_data(57) & eeprom_data(58) & eeprom_data(59);
          eeprom_params.tp2_int_high_limit   <= eeprom_data(60) & eeprom_data(61) & eeprom_data(62) & eeprom_data(63);
          eeprom_params.tp3_int_low_limit    <= eeprom_data(64) & eeprom_data(65) & eeprom_data(66) & eeprom_data(67);
          eeprom_params.tp3_int_high_limit   <= eeprom_data(68) & eeprom_data(69) & eeprom_data(70) & eeprom_data(71);
          eeprom_params.tp1_peak_low_limit   <= eeprom_data(72) & eeprom_data(73) & eeprom_data(74) & eeprom_data(75);
          eeprom_params.tp1_peak_high_limit  <= eeprom_data(76) & eeprom_data(77) & eeprom_data(78) & eeprom_data(79);
          eeprom_params.tp2_peak_low_limit   <= eeprom_data(80) & eeprom_data(81) & eeprom_data(82) & eeprom_data(83);
          eeprom_params.tp2_peak_high_limit  <= eeprom_data(84) & eeprom_data(85) & eeprom_data(86) & eeprom_data(87);
          eeprom_params.tp3_peak_low_limit   <= eeprom_data(88) & eeprom_data(89) & eeprom_data(90) & eeprom_data(91);
          eeprom_params.tp3_peak_high_limit  <= eeprom_data(92) & eeprom_data(93) & eeprom_data(94) & eeprom_data(95);
          eeprom_params.tp1_fwhm_low_limit   <= eeprom_data(96) & eeprom_data(97) & eeprom_data(98) & eeprom_data(99);
          eeprom_params.tp1_fwhm_high_limit  <= eeprom_data(100) & eeprom_data(101) & eeprom_data(102) & eeprom_data(103);
          eeprom_params.tp2_fwhm_low_limit   <= eeprom_data(104) & eeprom_data(105) & eeprom_data(106) & eeprom_data(107);
          eeprom_params.tp2_fwhm_high_limit  <= eeprom_data(108) & eeprom_data(109) & eeprom_data(110) & eeprom_data(111);
          eeprom_params.tp3_fwhm_low_limit   <= eeprom_data(112) & eeprom_data(113) & eeprom_data(114) & eeprom_data(115);
          eeprom_params.tp3_fwhm_high_limit  <= eeprom_data(116) & eeprom_data(117) & eeprom_data(118) & eeprom_data(119);
          eeprom_params.tp1_base_low_limit   <= eeprom_data(120) & eeprom_data(121) & eeprom_data(122) & eeprom_data(123);
          eeprom_params.tp1_base_high_limit  <= eeprom_data(124) & eeprom_data(125) & eeprom_data(126) & eeprom_data(127);
          eeprom_params.tp2_base_low_limit   <= eeprom_data(128) & eeprom_data(129) & eeprom_data(130) & eeprom_data(131);
          eeprom_params.tp2_base_high_limit  <= eeprom_data(132) & eeprom_data(133) & eeprom_data(134) & eeprom_data(135);
          eeprom_params.tp3_base_low_limit   <= eeprom_data(136) & eeprom_data(137) & eeprom_data(138) & eeprom_data(139);
          eeprom_params.tp3_base_high_limit  <= eeprom_data(140) & eeprom_data(141) & eeprom_data(142) & eeprom_data(143);
          eeprom_params.tp1_pos_level        <= eeprom_data(144) & eeprom_data(145) & eeprom_data(146) & eeprom_data(147);
          eeprom_params.tp2_pos_level        <= eeprom_data(148) & eeprom_data(149) & eeprom_data(150) & eeprom_data(151);
          eeprom_params.tp3_pos_level        <= eeprom_data(152) & eeprom_data(153) & eeprom_data(154) & eeprom_data(155); 
          eeprom_params.tp1_neg_level        <= eeprom_data(156) & eeprom_data(157) & eeprom_data(158) & eeprom_data(159);
          eeprom_params.tp2_neg_level        <= eeprom_data(160) & eeprom_data(161) & eeprom_data(162) & eeprom_data(163);
          eeprom_params.tp3_neg_level        <= eeprom_data(164) & eeprom_data(165) & eeprom_data(166) & eeprom_data(167); 
          eeprom_params.beamaccum_limit_hr   <= eeprom_data(168) & eeprom_data(169) & eeprom_data(170) & eeprom_data(171);
          eeprom_params.beamhigh_limit       <= eeprom_data(172) & eeprom_data(173) & eeprom_data(174) & eeprom_data(175);
          eeprom_params.baseline_low_limit   <= eeprom_data(176) & eeprom_data(177) & eeprom_data(178) & eeprom_data(179);
          eeprom_params.baseline_high_limit  <= eeprom_data(180) & eeprom_data(181) & eeprom_data(182) & eeprom_data(183);
          eeprom_params.charge_calibration   <= eeprom_data(184) & eeprom_data(185) & eeprom_data(186) & eeprom_data(187);
          eeprom_params.accum_q_min          <= eeprom_data(188) & eeprom_data(189) & eeprom_data(190) & eeprom_data(191);
          eeprom_params.accum_length         <= eeprom_data(192) & eeprom_data(193) & eeprom_data(194) & eeprom_data(195);    
          eeprom_params.crc32_eeprom         <= eeprom_data(196) & eeprom_data(197) & eeprom_data(198) & eeprom_data(199);
         end if;
         end if;
    end process;

end Behavioral;
