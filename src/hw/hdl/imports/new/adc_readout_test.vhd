----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2025 11:19:46 AM
-- Design Name: 
-- Module Name: adc_readout_test - Behavioral
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
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity adc_readout_test is
  Port ( 
        reset       : in std_logic; 
        sys_clk     : in std_logic;
        adc_d1d0    : in std_logic;
        adc_d3d2    : in std_logic;
        adc_d5d4    : in std_logic;
        adc_d7d6    : in std_logic;
        adc_d9d8    : in std_logic;
        adc_d11d10  : in std_logic;
        adc_d13d12  : in std_logic;
        adc_d15d14  : in std_logic;
        adc_sdo     : in std_logic;
        adc_sdi     : out std_logic;
        adc_sclk    : out std_logic; 
        adc_csb     : out std_logic;
        data_in     : in std_logic_vector(15 downto 0);
        adc_data_out : out std_logic_vector(15 downto 0);
        pulse_detect:  out std_logic;
        adc_data_2s  :out std_logic_vector(15 downto 0)
  );
end adc_readout_test;

architecture Behavioral of adc_readout_test is
    signal rd_data_internal : std_logic_vector(15 downto 0):= (others => '0');

    signal adc_sdo_internal : std_logic_vector(7 downto 0):= (others => '0'); 
    signal rd_data_integer :integer := 0; 
    
    constant SPI_CLK_DIV : integer := 25; -- Clock divider for 4 MHz SPI clock from 200 MHz sys clk -- 50% duty cycle

    signal clk_div_count : integer := 0;
    signal spi_clk_int   : std_logic := '0';

    type spi_state is (IDLE, WRITE, READ, DELAY, DONE);
    
    signal present_state      : spi_state := IDLE;
    signal next_state      : spi_state := IDLE;
    signal delay_cnt      : integer := 2; 
    
    type rx_state is (IDLE, RX, DONE_RX); 
    signal rxstate : rx_state; 
    

    signal bit_count      : integer := 15;
    signal shift_register : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_n_int       : std_logic := '1';
    signal sdi_int       : std_logic := '0';
    signal sdo_buffer_temp   : std_logic_vector(15 downto 0) := (others => '0');
    signal sdo_buffer   : std_logic_vector(15 downto 0) := (others => '0');
    
    signal rx_delay_cnt : integer := 0; 
    signal clk_enable     : std_logic := '0';
    signal clk_count      : integer := 0;
    signal csb_internal   : std_logic:= '1'; 
    signal adc_sclk_int   : std_logic_vector(4 downto 0):= (others => '0'); 
    signal adc_pipeline_cnt : integer := 7; 
    signal clk_count_temp  : integer := 0; 
    signal latency_flag    : std_logic:= '0';
    signal clk_debug   : std_logic;
    signal reset_debug : std_logic;   
    signal latency_val : integer; 
    signal data_debug     : std_logic_vector(15 downto 0);
    
     signal adc_data_in  : std_logic_vector(7 downto 0);
     signal adc_data_i   : std_logic_vector(15 downto 0);
     signal adc_clk_i    : std_logic;
     signal adc_clk_dlyd : std_logic;
     signal adc_clk_o    : std_logic;
     signal adc_of       : std_logic;
     signal sample_cnt   : integer := 0;
    
  
      COMPONENT adc_interface_ila
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
        probe2 : IN STD_LOGIC;
        probe3 : IN integer;
        probe4 : IN STD_LOGIC;
        probe5 : IN STD_LOGIC; 
        probe6 : IN STD_LOGIC; 
        probe7 : IN STD_LOGIC; 
        probe8 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        probe9 : IN spi_state
    );
    END COMPONENT  ;
    

begin
    
-- DEBUG PORTS ------------------------------------
  
    
--        adc_ila : adc_interface_ila
--    PORT MAP (
--        clk => sys_clk,
--        probe0 => adc_data_out, 
--        probe1 => adc_data_2s, 
--        probe2 => pulse_detect,
--        probe3 => adc_pipeline_cnt,
--        probe4 => latency_flag,
--        probe5 => adc_sdi, 
--        probe6 => adc_sclk, 
--        probe7 => adc_csb, 
--        probe8 => data_in,
--        probe9 => present_state
--    );
-----------------------------------------------------
 
   IDDR_inst0 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(1), -- posedge
       Q2 => rd_data_internal(0), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d1d0,
       R => '0',
       S => '0'
    );

   IDDR_inst1 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(3), -- posedge
       Q2 => rd_data_internal(2), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d3d2,
       R => '0',
       S => '0'
    );
    
   IDDR_inst2 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(5), -- posedge
       Q2 => rd_data_internal(4), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d5d4,
       R => '0',
       S => '0'
    );
    
    IDDR_inst3 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(7), -- posedge
       Q2 => rd_data_internal(6), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d7d6,
       R => '0',
       S => '0'
    );
    
    IDDR_inst4 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(9), -- posedge
       Q2 => rd_data_internal(8), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d9d8,
       R => '0',
       S => '0'
    );
    
    IDDR_inst5 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(11), -- posedge
       Q2 => rd_data_internal(10), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d11d10,
       R => '0',
       S => '0'
    );
    
    IDDR_inst6 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(13), -- posedge
       Q2 => rd_data_internal(12), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d13d12,
       R => '0',
       S => '0'
    );
    IDDR_inst7 : IDDR
    generic map (
       DDR_CLK_EDGE => "SAME_EDGE",
       INIT_Q1 => '0',
       INIT_Q2 => '0',
       SRTYPE => "SYNC")
    port map (
       Q1 => rd_data_internal(15), -- posedge
       Q2 => rd_data_internal(14), -- negedge
       C => sys_clk,
       CE => '1',
       D => adc_d15d14,
       R => '0',
       S => '0'
    );
    -- reads the adc output
    rd_output: process(sys_clk) begin 
        if(rising_edge(sys_clk)) then  
         if (reset = '1') then 
            adc_data_out <= (others => '0'); 
            adc_data_2s <= (others => '0'); 
         else
            adc_data_out <= rd_data_internal;  
            adc_data_2s <= x"8000" xor rd_data_internal;
         end if;
        end if;  
    end process; 
    
    pulse_detect <= '1' when unsigned(adc_data_out) < 32000 else '0';   
    
------------------------------------------------------------------------------------------------
--    -- Generates 4 MHz SPI clock
    process(sys_clk)
    begin
        if rising_edge(sys_clk) then
               if reset = '1' then
                clk_div_count <= 0;
               else
                if clk_count = SPI_CLK_DIV - 1 then
                    clk_count_temp <= 0; 
                    clk_enable <= not(clk_enable);
                else
                    clk_count_temp <= clk_count_temp + 1;
                end if;
                clk_count <= clk_count_temp;
               end if; 
        end if;
    end process;
    


    spi_clk: process(sys_clk) begin -- produces the sclk output going to the ltc2107 spi
        if(rising_edge(sys_clk)) then
            if reset = '1' then 
                adc_sclk <= '0'; 
            else 
                if(csb_internal = '1' or present_state = DONE or present_state = DELAY) then  --stops sending clk pulses when it reaches these conditions
                    adc_sclk <= adc_sclk; 
                else
                    adc_sclk <= clk_enable; 
                end if; 
            end if; 
        end if; 
    end process;  
    
    state_logic: process(clk_enable) begin --updates the present state
       if(rising_edge(clk_enable)) then 
            if(reset = '1') then 
                present_state <= IDLE; 
            else
               present_state <= next_state; 
            end if; 
       end if; 
    end process; 
    
    -- SPI state machine
    fsm: process(clk_enable)
    begin
        if falling_edge(clk_enable) then
            case present_state is
                when IDLE =>
                        adc_sdi <= '0';
                        
                    if(reset = '0') then 
                       shift_register <= data_in;
                       bit_count <= 15;
                       next_state <= DELAY;
                    else
                       shift_register <= x"0080";
                       bit_count <= 15;
                       next_state <= DELAY;
                    end if;
           
                    
                when DELAY =>
                
                        if delay_cnt = 0 then 
                            delay_cnt <= 2; 
                            if data_in(15) = '0' then 
                            adc_sdi <= shift_register(15); 
                               next_state <= WRITE; 
                            else 
                            adc_sdi <= shift_register(15); 
                                next_state <= READ; 
                            end if;                           
                        else 
                        
                            delay_cnt <= delay_cnt -1;   
                        end if; 

                when WRITE =>
                
                        if( bit_count - 1 < 0) then 
                            adc_sdi <= shift_register(0); 
                        else
                            adc_sdi <= shift_register(bit_count -1);
                        end if; 
                        
                        if bit_count = 0 then
                        
                            next_state <= DONE;
                        else
                            bit_count <= bit_count - 1;
                            next_state <= WRITE; 
                        end if;
                   
                when READ =>
                
                        adc_sdi <= shift_register(bit_count);
                        
                        
                        if(bit_count  <= 7) then 
                                sdo_buffer_temp(bit_count + 8) <= adc_sdo; -- Store read bits in higher byte
                        end if;
                            
                        if bit_count = 0 then
                            next_state <= DONE;
                        else
                            bit_count <= bit_count - 1;
                            next_state <= READ;
                        end if;
                 when DONE =>
                       adc_sdi <= '0'; 
                       sdo_buffer <= sdo_buffer_temp; 
                       if delay_cnt = 0 then 
                            delay_cnt <= 1; 
                            next_state <= IDLE;                           
                        else 
                            delay_cnt <= delay_cnt -1;   
                        end if;   
                         

                when others =>
                    next_state <= IDLE;
            end case;
        end if;
    end process;
   


-------------------------------------------------------------------------------------------------------
    
       --generates the adc_csb signal based on the present statedata_out_temp
       csb: process(reset, present_state) begin 
        if(reset = '1') then 
            csb_internal <= '1'; 
        else
                case present_state is
                 when IDLE => csb_internal <= '1'; 
                 when DELAY => csb_internal <= '0';
                 when WRITE => csb_internal <= '0'; 
                 when READ => csb_internal <= '0'; 
                 when DONE => csb_internal <= '1';  
                 when others => csb_internal <= '1'; 
                end case;
        end if; 
    end process; 
    
    adc_csb <= csb_internal; 

    
    

end Behavioral;
