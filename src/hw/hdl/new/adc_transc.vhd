----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2025 10:10:36 AM
-- Design Name: 
-- Module Name: sfp_gtp - Behavioral
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

entity adc_transc is
  Port (
    sys_clk_p : in std_logic;
    sys_clk_n : in std_logic;  
--    reset: in std_logic; 
    gtp_refclk0_p: in std_logic; 
    gtp_refclk0_n: in std_logic; 
    gtp_refclk1_p: in std_logic; 
    gtp_refclk1_n: in std_logic;
    q0_clk0_refclk_out: out std_logic; 
--    gtp_tx_data: in std_logic_vector(31 downto 0); 
--    gtp_tx_data_enb: in std_logic; 
--    gtp_rx_data: out std_logic_vector(31 downto 0);
    rxoutclk_fabric : out std_logic; 
    clk_debug: out std_logic; 
    gt0_rxoutclk: out std_logic;
    gt0_txoutclk: out std_logic;
    txusrclk_out : out std_logic; 
    txusrclk2_out: out std_logic;
    rxusrclk_out : out std_logic; 
    rxusrclk2_out: out std_logic;  
    rxn_in : in std_logic; 
    rxp_in : in std_logic; 
    txn_out : out std_logic; 
    txp_out : out std_logic
   );
end adc_transc;

architecture Behavioral of adc_transc is
    signal reset: std_logic;
  signal  gtp_tx_data:  std_logic_vector(31 downto 0); 
  signal  gtp_tx_data_enb:  std_logic; 
    signal gtp_rx_clk_p : std_logic:= '0'; 
    signal gtp_rx_clk_n : std_logic:= '0';
--    signal     q0_clk0_refclk_out: std_logic;  
    signal gtp_rx_data: std_logic_vector(31 downto 0); 
    
    signal tx_data : std_logic_vector(31 downto 0); 
    signal rx_data : std_logic_vector(31 downto 0); 
    
    signal gtp_tx_clk_p : std_logic:= '0'; 
    signal gtp_tx_clk_n : std_logic:= '0'; 
    
    signal ibert_txp : std_logic_vector(3 downto 0); 
    signal ibert_txn : std_logic_vector(3 downto 0);
    
    signal ibert_rxp : std_logic_vector(3 downto 0); 
    signal ibert_rxn : std_logic_vector(3 downto 0);  
    
    signal  gt0_rxoutclk_i                  : std_logic;
    
    signal refclk: std_logic; 
    
    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_out0 : OUT STD_LOGIC;
        probe_out1 : OUT STD_LOGIC_VECTOR(2 downto 0);
        probe_out2 : OUT STD_LOGIC; 
        probe_out3 : OUT STD_LOGIC_VECTOR(2 downto 0);
        probe_out4 : OUT STD_LOGIC_VECTOR(2 downto 0) 
      );
    END COMPONENT;
    
    COMPONENT ila_0
    
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
        probe2 : IN STD_LOGIC;
        probe3 : IN STD_LOGIC_VECTOR(3 downto 0);
        probe4 : IN STD_LOGIC;
        probe5 : IN STD_LOGIC;
        probe6 : IN STD_LOGIC;
        probe7 : IN STD_LOGIC;
        probe8 : IN STD_LOGIC;
        probe9 : IN STD_LOGIC;
        probe10 : IN STD_LOGIC
    );
    END COMPONENT  ;    
    
    component ibert_7series_gtp_0 
    port(
            TXN_O: out std_logic_vector(3 downto 0); 
            TXP_O: out std_logic_vector(3 downto 0); 
            RXOUTCLK_O: out std_logic; 
            RXN_I: in std_logic_vector(3 downto 0); 
            RXP_I: in std_logic_vector(3 downto 0); 
            GTREFCLK0_I: in std_logic; 
            GTREFCLK1_I: in std_logic; 
            SYSCLK_I: in std_logic
    ); end component; 
    
    component gtwizard_0_support
generic
(
    EXAMPLE_SIM_GTRESET_SPEEDUP             : string    := "TRUE";     -- simulation setting for GT SecureIP model
    STABLE_CLOCK_PERIOD                     : integer   := 10  

);
port
(
    SOFT_RESET_TX_IN                        : in   std_logic;
    SOFT_RESET_RX_IN                        : in   std_logic;
    DONT_RESET_ON_DATA_ERROR_IN             : in   std_logic;
    Q0_CLK1_GTREFCLK_PAD_N_IN               : in   std_logic;
    Q0_CLK1_GTREFCLK_PAD_P_IN               : in   std_logic;

    GT0_TX_FSM_RESET_DONE_OUT               : out  std_logic;
    GT0_RX_FSM_RESET_DONE_OUT               : out  std_logic;
    GT0_DATA_VALID_IN                       : in   std_logic;
    GT0_TX_MMCM_LOCK_OUT                    : out  std_logic;
    GT0_RX_MMCM_LOCK_OUT                    : out  std_logic;
 
    GT0_TXUSRCLK_OUT                        : out  std_logic;
    GT0_TXUSRCLK2_OUT                       : out  std_logic;
    GT0_RXUSRCLK_OUT                        : out  std_logic;
    GT0_RXUSRCLK2_OUT                       : out  std_logic;
    refclk                                  : out std_logic; 
    --_________________________________________________________________________
    --GT0  (X0Y0)
    --____________________________CHANNEL PORTS________________________________
    ---------------------------- Channel - DRP Ports  --------------------------
    gt0_drpaddr_in                          : in   std_logic_vector(8 downto 0);
    gt0_drpdi_in                            : in   std_logic_vector(15 downto 0);
    gt0_drpdo_out                           : out  std_logic_vector(15 downto 0);
    gt0_drpen_in                            : in   std_logic;
    gt0_drprdy_out                          : out  std_logic;
    gt0_drpwe_in                            : in   std_logic;
    --------------------- RX Initialization and Reset Ports --------------------
    gt0_eyescanreset_in                     : in   std_logic;
    gt0_rxuserrdy_in                        : in   std_logic;
            ------------------------------- Loopback Ports -----------------------------
    gt0_loopback_in                         : in   std_logic_vector(2 downto 0);
        ------------------- Receive Ports - Pattern Checker ports ------------------
    gt0_rxprbscntreset_in                   : in   std_logic;
    -------------------------- RX Margin Analysis Ports ------------------------
    gt0_eyescandataerror_out                : out  std_logic;
    gt0_eyescantrigger_in                   : in   std_logic;
    ------------------ Receive Ports - FPGA RX Interface Ports -----------------
    gt0_rxdata_out                          : out  std_logic_vector(31 downto 0);
    ------------------ Receive Ports - RX 8B/10B Decoder Ports -----------------
    gt0_rxchariscomma_out                   : out  std_logic_vector(3 downto 0);
    gt0_rxcharisk_out                       : out  std_logic_vector(3 downto 0);
    gt0_rxdisperr_out                       : out  std_logic_vector(3 downto 0);
    gt0_rxnotintable_out                    : out  std_logic_vector(3 downto 0);
    ------------------------ Receive Ports - RX AFE Ports ----------------------
    gt0_gtprxn_in                           : in   std_logic;
    gt0_gtprxp_in                           : in   std_logic;
            ------------------------- Receive Ports - CDR Ports ------------------------
    gt0_rxcdrhold_in                        : in   std_logic;
            ------------------- Receive Ports - Pattern Checker Ports ------------------
    gt0_rxprbserr_out                       : out  std_logic;
    gt0_rxprbssel_in                        : in   std_logic_vector(2 downto 0);
    -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
    gt0_rxcommadet_out                      : out  std_logic;
    gt0_rxmcommaalignen_in                  : in   std_logic;
    gt0_rxpcommaalignen_in                  : in   std_logic;
    ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
    gt0_dmonitorout_out                     : out  std_logic_vector(14 downto 0);
    -------------------- Receive Ports - RX Equailizer Ports -------------------
    gt0_rxlpmhfhold_in                      : in   std_logic;
    gt0_rxlpmlfhold_in                      : in   std_logic;
    --------------- Receive Ports - RX Fabric Output Control Ports -------------
    gt0_rxoutclk_out                        : out  std_logic;
    gt0_rxoutclkfabric_out                  : out  std_logic;
    ------------- Receive Ports - RX Initialization and Reset Ports ------------
    gt0_gtrxreset_in                        : in   std_logic;
    gt0_rxlpmreset_in                       : in   std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    gt0_rxpolarity_in                       : in   std_logic;
    -------------- Receive Ports -RX Initialization and Reset Ports ------------
    gt0_rxresetdone_out                     : out  std_logic;
    --------------------- TX Initialization and Reset Ports --------------------
    gt0_gttxreset_in                        : in   std_logic;
    gt0_txuserrdy_in                        : in   std_logic;
    ------------------ Transmit Ports - FPGA TX Interface Ports ----------------
    gt0_txdata_in                           : in   std_logic_vector(31 downto 0);
    ------------------ Transmit Ports - TX 8B/10B Encoder Ports ----------------
    gt0_txcharisk_in                        : in   std_logic_vector(3 downto 0);
    --------------- Transmit Ports - TX Configurable Driver Ports --------------
    gt0_gtptxn_out                          : out  std_logic;
    gt0_gtptxp_out                          : out  std_logic;
    ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    gt0_txoutclk_out                        : out std_logic; 
    gt0_txoutclkfabric_out                  : out  std_logic;
    gt0_txoutclkpcs_out                     : out  std_logic;
    ------------- Transmit Ports - TX Initialization and Reset Ports -----------
    gt0_txresetdone_out                     : out  std_logic;
        ------------------ Transmit Ports - pattern Generator Ports ----------------
    gt0_txprbssel_in                        : in   std_logic_vector(2 downto 0);

    --____________________________COMMON PORTS________________________________
   GT0_PLL0RESET_OUT  : out std_logic;
         GT0_PLL0OUTCLK_OUT  : out std_logic;
         GT0_PLL0OUTREFCLK_OUT  : out std_logic;
         GT0_PLL0LOCK_OUT  : out std_logic;
         GT0_PLL0REFCLKLOST_OUT  : out std_logic;    
         GT0_PLL1OUTCLK_OUT  : out std_logic;
         GT0_PLL1OUTREFCLK_OUT  : out std_logic;
       sysclk_in        : in std_logic

); end component;

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  -- Status and control signals
--  reset             : in     std_logic;
  clk_in1_p         : in     std_logic;
  clk_in1_n         : in     std_logic
 );
end component;
    
--    signal txusrclk_out : std_logic; 
--    signal txusrclk2_out: std_logic;
    
    signal txclkout_buf : std_logic;  
    signal rxclkout_buf : std_logic;  
    
--    signal rxusrclk_out : std_logic; 
--    signal rxusrclk2_out: std_logic; 
    
    signal rxcharisk: std_logic_vector(3 downto 0); 
    signal rxresetdone: std_logic; 
    signal fsm_rxresetdone: std_logic; 
    signal fsm_txresetdone: std_logic; 
    signal data_valid: std_logic; 
--    signal clk_debug: std_logic; 
    
    signal txcharisk: std_logic_vector(3 downto 0); 
    signal clk : std_logic; 
    signal rxp_internal : std_logic; 
    signal rxn_internal : std_logic;
    signal ibert_refclk_i : std_logic; 
    signal rx_data_internal: std_logic_vector(31 downto 0);
    signal prev_rx_data: std_logic_vector(31 downto 0);
    
    
    signal gtp_refclk_intp : std_logic;    
    signal gtp_refclk_intn : std_logic;
    signal gtp_refclk0_buf_out : std_logic; 
    signal gtp_refclk1_buf_out : std_logic; 
    signal Mhz100_clk: std_logic; 
    signal txcnt : integer:= 0; 
    signal pll0clkout : std_logic; 
    signal pll0clkout_buf : std_logic; 
    signal pll0reset : std_logic; 
    signal pll0refclk : std_logic; 
    signal pll0refclk_buf : std_logic; 
    signal pll0lock : std_logic; 
    signal pll0refclklost : std_logic; 
    signal loopback_in  : std_logic_vector(2 downto 0); 
    signal rxprbsreset_in : std_logic; 
    signal rxerrorcnt_out : std_logic;
    signal rxprbssel_in   : std_logic_vector(2 downto 0);  
    signal txprbssel_in   : std_logic_vector(2 downto 0);

--    -- ATTRIBUTE DECLARATION --  
ATTRIBUTE MARK_DEBUG : STRING;
ATTRIBUTE MARK_DEBUG OF reset : SIGNAL IS "true";
ATTRIBUTE MARK_DEBUG OF txusrclk_out : SIGNAL IS "true";
ATTRIBUTE MARK_DEBUG OF txusrclk2_out : SIGNAL IS "true";
ATTRIBUTE MARK_DEBUG OF rxusrclk_out : SIGNAL IS "true";
ATTRIBUTE MARK_DEBUG OF rxusrclk2_out : SIGNAL IS "true";
begin
    vio : vio_0
      PORT MAP (
        clk => clk,
        probe_out0 => reset,
        probe_out1 => loopback_in,
        probe_out2 => rxprbsreset_in,
        probe_out3 => rxprbssel_in,
        probe_out4 => txprbssel_in
      );
   
    ila : ila_0
    PORT MAP (
        clk => clk,
        probe0 => gtp_rx_data, 
        probe1 => tx_data, 
        probe2 => rxresetdone,
        probe3 => rxcharisk,
        probe4 => fsm_rxresetdone,
        probe5 => fsm_txresetdone,
        probe6 => refclk, 
        probe7 => gt0_rxoutclk_i, 
        probe8 => rxusrclk2_out, 
        probe9 => txusrclk2_out, 
        probe10 => rxerrorcnt_out
    );
    
--     ibert: ibert_7series_gtp_0
--      PORT MAP (
--        TXN_O => ibert_txn,
--        TXP_O => ibert_txp,
--        RXOUTCLK_O => q0_clk0_refclk_out,
--        RXN_I => ibert_rxn,
--        RXP_I => ibert_rxp,
--        GTREFCLK0_I => gtp_refclk0_buf_out,
--        GTREFCLK1_I => gtp_refclk1_buf_out,
--        SYSCLK_I => clk
--      );

Mhz100 : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out2 => clk,
   clk_out1 => Mhz100_clk,
  -- Status and control signals                
   -- Clock in ports
   clk_in1_p => sys_clk_p,
   clk_in1_n => sys_clk_n
 );
 
 clk_debug <= Mhz100_clk; 

--gtp_refclk0: IBUFDS_GTE2 
--     port map (
--        O     => gtp_refclk0_buf_out,
--        ODIV2 => open,
--        CEB   => '0',
--        I     =>  gtp_refclk0_p,
--        IB    => gtp_refclk0_n
--      );
--gtp_refclk1: IBUFDS_GTE2 
--     port map (
--        O     => gtp_refclk1_buf_out,
--        ODIV2 => open,
--        CEB   => '0',
--        I     =>  gtp_refclk1_p,
--        IB    => gtp_refclk1_n
--      );
    
--    sys_clk_inst : IBUFDS
--    port map (
--       O => clk,  -- Buffer output
--       I => sys_clk_p,  -- Diff_p buffer input (connect directly to top-level port)
--       IB => sys_clk_n -- Diff_n buffer input (connect directly to top-level port)
--    );
    
    gtwizard_0_i : gtwizard_0_support
    port map
    (
        SOFT_RESET_TX_IN => reset,
        SOFT_RESET_RX_IN => reset,
        DONT_RESET_ON_DATA_ERROR_IN => '1',
        Q0_CLK1_GTREFCLK_PAD_N_IN => gtp_refclk1_n,
        Q0_CLK1_GTREFCLK_PAD_P_IN => gtp_refclk1_p,
    
         GT0_TX_FSM_RESET_DONE_OUT => fsm_txresetdone,
         GT0_RX_FSM_RESET_DONE_OUT => fsm_rxresetdone,
         GT0_DATA_VALID_IN => '1',
         GT0_TX_MMCM_LOCK_OUT => open,
     
         GT0_TXUSRCLK_OUT => txusrclk_out,
         GT0_TXUSRCLK2_OUT => txusrclk2_out,
         GT0_RXUSRCLK_OUT => rxusrclk_out,
         GT0_RXUSRCLK2_OUT => rxusrclk2_out,
          refclk => q0_clk0_refclk_out,
        --_________________________________________________________________________
        --GT0  (X0Y0)
        --____________________________CHANNEL PORTS________________________________
        ---------------------------- Channel - DRP Ports  --------------------------
            gt0_drpaddr_in                  =>      (others => '0'),
            gt0_drpdi_in                    =>      (others => '0'),
            gt0_drpdo_out                   =>      open,
            gt0_drpen_in                    =>      '1',
            gt0_drprdy_out                  =>      open,
            gt0_drpwe_in                    =>      '0',
        --------------------- RX Initialization and Reset Ports --------------------
            gt0_eyescanreset_in             =>      '0',
            gt0_rxuserrdy_in                =>      '1',
        -------------------------- RX Margin Analysis Ports ------------------------
            gt0_eyescandataerror_out        =>      open,
            gt0_eyescantrigger_in           =>      '0',
        ------------------ Receive Ports - FPGA RX Interface Ports -----------------
            gt0_rxdata_out                  =>      rx_data_internal,
                        ------------------------------- Loopback Ports -----------------------------
            gt0_loopback_in                         => loopback_in,
        ------------------- Receive Ports - Pattern Checker ports ------------------
            gt0_rxprbscntreset_in                   => rxprbsreset_in,
            gt0_rxcdrhold_in     => '0',
        ------------------ Receive Ports - RX 8B/10B Decoder Ports -----------------
            gt0_rxchariscomma_out           =>      open,
            gt0_rxcharisk_out               =>      rxcharisk,
            gt0_rxdisperr_out               =>      open,
            gt0_rxnotintable_out            =>      open,
        ------------------------ Receive Ports - RX AFE Ports ----------------------
            gt0_gtprxn_in                   =>      rxn_in,
            gt0_gtprxp_in                   =>      rxp_in,
                        ------------------- Receive Ports - Pattern Checker Ports ------------------
    gt0_rxprbserr_out                       => rxerrorcnt_out,
    gt0_rxprbssel_in                        => rxprbssel_in, 
                -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
            gt0_rxcommadet_out                      => open,
            gt0_rxmcommaalignen_in                  => '1',
            gt0_rxpcommaalignen_in                  => '1',
        ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
            gt0_dmonitorout_out             =>      open,
        -------------------- Receive Ports - RX Equailizer Ports -------------------
            gt0_rxlpmhfhold_in              =>      '0',
            gt0_rxlpmlfhold_in              =>      '0',
        --------------- Receive Ports - RX Fabric Output Control Ports -------------
            gt0_rxoutclk_out                =>      gt0_rxoutclk,
            gt0_rxoutclkfabric_out          =>      rxoutclk_fabric,
        ------------- Receive Ports - RX Initialization and Reset Ports ------------
            gt0_gtrxreset_in                =>      '0',
            gt0_rxlpmreset_in               =>      '0',
        -------------- Receive Ports -RX Initialization and Reset Ports ------------
            gt0_rxresetdone_out             =>      rxresetdone,
            gt0_rxpolarity_in               => '1',
        --------------------- TX Initialization and Reset Ports --------------------
            gt0_gttxreset_in                =>      '0',
            gt0_txuserrdy_in                =>      '1',
        ------------------ Transmit Ports - FPGA TX Interface Ports ----------------
            gt0_txdata_in                   =>      tx_data,
        ------------------ Transmit Ports - TX 8B/10B Encoder Ports ----------------
            gt0_txcharisk_in                =>      txcharisk,
        --------------- Transmit Ports - TX Configurable Driver Ports --------------
            gt0_gtptxn_out                  =>      txn_out,
            gt0_gtptxp_out                  =>      txp_out,
        ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
            gt0_txoutclk_out                =>     gt0_txoutclk,
            gt0_txoutclkfabric_out          =>      open,
            gt0_txoutclkpcs_out             =>      open,
        ------------- Transmit Ports - TX Initialization and Reset Ports -----------
            gt0_txresetdone_out             =>      open,
        ------------------ Transmit Ports - pattern Generator Ports ----------------
            gt0_txprbssel_in                => txprbssel_in,  
        --____________________________COMMON PORTS________________________________
             GT0_PLL0RESET_OUT  => pll0reset,
             GT0_PLL0OUTCLK_OUT  => open,
             GT0_PLL0OUTREFCLK_OUT  => open,
             GT0_PLL0LOCK_OUT  => pll0lock,
             GT0_PLL0REFCLKLOST_OUT  => pll0refclklost,    
             GT0_PLL1OUTCLK_OUT  => open,
             GT0_PLL1OUTREFCLK_OUT  => open,
         sysclk_in => Mhz100_clk
    
    );
    
    
--    write_tx: process(txusrclk_out, reset) 
--    begin 
--        if reset = '1' then 
--            tx_data <= (others => '0'); 
--        else 
--            if rising_edge(txusrclk_out) then 
--                if gtp_tx_data_enb = '1' then 
--                    tx_data <= gtp_tx_data;    
--                end if; 
--            end if; 
--        end if; 
--    end process;


process(rxusrclk2_out) 
begin
    if(rising_edge(rxusrclk2_out)) then 
        prev_rx_data <= rx_data_internal; 
    end if; 
end process;
 
process (rxusrclk2_out) 
begin 
    if(rising_edge(rxusrclk2_out)) then 
        if(reset = '1') then 
            gtp_rx_data <= (others => '0'); 
        else 
            if(rxcharisk = x"0" or rxcharisk = x"1") then 
                gtp_rx_data <= rx_data_internal;
            elsif(rxcharisk = x"2") then 
                gtp_rx_data <= rx_data_internal(7 downto 0) & prev_rx_data(31 downto 8); 
            elsif(rxcharisk = x"4") then 
                gtp_rx_data <= rx_data_internal(15 downto 0) & prev_rx_data(31 downto 16); 
            elsif(rxcharisk = x"8") then 
                gtp_rx_data <= rx_data_internal(23 downto 0) & prev_rx_data(31 downto 24);     
            else
                gtp_rx_data <= (others => '0'); 
            end if; 
        end if; 
    end if; 


end process; 

process (txusrclk2_out)
begin
  if (rising_edge(txusrclk2_out)) then
    if (reset = '1') then
      tx_data <= x"000050BC";
      txcharisk <= x"1";
      txcnt <= 0;
    else
      if (txcnt = 500) then
        tx_data <= x"000050BC";
        txcharisk <= x"1";
        txcnt <= 0; 
      else
        tx_data <= std_logic_vector(to_unsigned(txcnt,32));
        txcharisk <= x"0";
        txcnt <= txcnt + 1;
      end if;
    end if;
  end if;
end process;

end Behavioral;
