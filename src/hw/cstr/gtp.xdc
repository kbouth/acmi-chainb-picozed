


create_clock -period 6.400 [get_ports gtp_refclk1_p]

set_property PACKAGE_PIN F10 [get_ports gtp_refclk1_p]
set_property PACKAGE_PIN E10 [get_ports gtp_refclk1_n]

# GTP Transceiver Channel X0Y4 (Quad 115)
#set_property PACKAGE_PIN G6 [get_ports gtp_rx0_p]
#set_property PACKAGE_PIN G5 [get_ports gtp_rx0_n]
#set_property PACKAGE_PIN F4 [get_ports gtp_tx0_p]
#set_property PACKAGE_PIN F3 [get_ports gtp_tx0_n]
#set_property IOSTANDARD DIFF_SSTL18 [get_ports {gtp_tx0_p gtp_tx0_n gtp_rx0_p gtp_rx0_n}]


##---------- Set placement for gt0_gtp_wrapper_i/GTPE2_CHANNEL ------
set_property LOC GTPE2_CHANNEL_X0Y4 [get_cells backend_gtp/gtp_trans/gtwizard_0_i/gtwizard_0_init_i/U0/gtwizard_0_i/gt0_gtwizard_0_i/gtpe2_i]






