


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



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list adc/adc_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {baseline[0]} {baseline[1]} {baseline[2]} {baseline[3]} {baseline[4]} {baseline[5]} {baseline[6]} {baseline[7]} {baseline[8]} {baseline[9]} {baseline[10]} {baseline[11]} {baseline[12]} {baseline[13]} {baseline[14]} {baseline[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {beam_adc_delay_dbg[0]} {beam_adc_delay_dbg[1]} {beam_adc_delay_dbg[2]} {beam_adc_delay_dbg[3]} {beam_adc_delay_dbg[4]} {beam_adc_delay_dbg[5]} {beam_adc_delay_dbg[6]} {beam_adc_delay_dbg[7]} {beam_adc_delay_dbg[8]} {beam_adc_delay_dbg[9]} {beam_adc_delay_dbg[10]} {beam_adc_delay_dbg[11]} {beam_adc_delay_dbg[12]} {beam_adc_delay_dbg[13]} {beam_adc_delay_dbg[14]} {beam_adc_delay_dbg[15]} {beam_adc_delay_dbg[16]} {beam_adc_delay_dbg[17]} {beam_adc_delay_dbg[18]} {beam_adc_delay_dbg[19]} {beam_adc_delay_dbg[20]} {beam_adc_delay_dbg[21]} {beam_adc_delay_dbg[22]} {beam_adc_delay_dbg[23]} {beam_adc_delay_dbg[24]} {beam_adc_delay_dbg[25]} {beam_adc_delay_dbg[26]} {beam_adc_delay_dbg[27]} {beam_adc_delay_dbg[28]} {beam_adc_delay_dbg[29]} {beam_adc_delay_dbg[30]} {beam_adc_delay_dbg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {send_results/tx_data[0]} {send_results/tx_data[1]} {send_results/tx_data[2]} {send_results/tx_data[3]} {send_results/tx_data[4]} {send_results/tx_data[5]} {send_results/tx_data[6]} {send_results/tx_data[7]} {send_results/tx_data[8]} {send_results/tx_data[9]} {send_results/tx_data[10]} {send_results/tx_data[11]} {send_results/tx_data[12]} {send_results/tx_data[13]} {send_results/tx_data[14]} {send_results/tx_data[15]} {send_results/tx_data[16]} {send_results/tx_data[17]} {send_results/tx_data[18]} {send_results/tx_data[19]} {send_results/tx_data[20]} {send_results/tx_data[21]} {send_results/tx_data[22]} {send_results/tx_data[23]} {send_results/tx_data[24]} {send_results/tx_data[25]} {send_results/tx_data[26]} {send_results/tx_data[27]} {send_results/tx_data[28]} {send_results/tx_data[29]} {send_results/tx_data[30]} {send_results/tx_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {send_results/present_state[0]} {send_results/present_state[1]} {send_results/present_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {peak_index[0]} {peak_index[1]} {peak_index[2]} {peak_index[3]} {peak_index[4]} {peak_index[5]} {peak_index[6]} {peak_index[7]} {peak_index[8]} {peak_index[9]} {peak_index[10]} {peak_index[11]} {peak_index[12]} {peak_index[13]} {peak_index[14]} {peak_index[15]} {peak_index[16]} {peak_index[17]} {peak_index[18]} {peak_index[19]} {peak_index[20]} {peak_index[21]} {peak_index[22]} {peak_index[23]} {peak_index[24]} {peak_index[25]} {peak_index[26]} {peak_index[27]} {peak_index[28]} {peak_index[29]} {peak_index[30]} {peak_index[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {integral[0]} {integral[1]} {integral[2]} {integral[3]} {integral[4]} {integral[5]} {integral[6]} {integral[7]} {integral[8]} {integral[9]} {integral[10]} {integral[11]} {integral[12]} {integral[13]} {integral[14]} {integral[15]} {integral[16]} {integral[17]} {integral[18]} {integral[19]} {integral[20]} {integral[21]} {integral[22]} {integral[23]} {integral[24]} {integral[25]} {integral[26]} {integral[27]} {integral[28]} {integral[29]} {integral[30]} {integral[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 17 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {peak[0]} {peak[1]} {peak[2]} {peak[3]} {peak[4]} {peak[5]} {peak[6]} {peak[7]} {peak[8]} {peak[9]} {peak[10]} {peak[11]} {peak[12]} {peak[13]} {peak[14]} {peak[15]} {peak[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 16 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {fwhm[0]} {fwhm[1]} {fwhm[2]} {fwhm[3]} {fwhm[4]} {fwhm[5]} {fwhm[6]} {fwhm[7]} {fwhm[8]} {fwhm[9]} {fwhm[10]} {fwhm[11]} {fwhm[12]} {fwhm[13]} {fwhm[14]} {fwhm[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {eeprom/bytes[0]} {eeprom/bytes[1]} {eeprom/bytes[2]} {eeprom/bytes[3]} {eeprom/bytes[4]} {eeprom/bytes[5]} {eeprom/bytes[6]} {eeprom/bytes[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {eeprom/address[0]} {eeprom/address[1]} {eeprom/address[2]} {eeprom/address[3]} {eeprom/address[4]} {eeprom/address[5]} {eeprom/address[6]} {eeprom/address[7]} {eeprom/address[8]} {eeprom/address[9]} {eeprom/address[10]} {eeprom/address[11]} {eeprom/address[12]} {eeprom/address[13]} {eeprom/address[14]} {eeprom/address[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 3 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {eeprom/eeprom_state__0[0]} {eeprom/eeprom_state__0[1]} {eeprom/eeprom_state__0[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 3 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {eeprom/eeprom_state[0]} {eeprom/eeprom_state[1]} {eeprom/eeprom_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {eeprom/opcode[0]} {eeprom/opcode[1]} {eeprom/opcode[2]} {eeprom/opcode[3]} {eeprom/opcode[4]} {eeprom/opcode[5]} {eeprom/opcode[6]} {eeprom/opcode[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {eeprom/rddata[0]} {eeprom/rddata[1]} {eeprom/rddata[2]} {eeprom/rddata[3]} {eeprom/rddata[4]} {eeprom/rddata[5]} {eeprom/rddata[6]} {eeprom/rddata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {send_results/count[0]} {send_results/count[1]} {send_results/count[2]} {send_results/count[3]} {send_results/count[4]} {send_results/count[5]} {send_results/count[6]} {send_results/count[7]} {send_results/count[8]} {send_results/count[9]} {send_results/count[10]} {send_results/count[11]} {send_results/count[12]} {send_results/count[13]} {send_results/count[14]} {send_results/count[15]} {send_results/count[16]} {send_results/count[17]} {send_results/count[18]} {send_results/count[19]} {send_results/count[20]} {send_results/count[21]} {send_results/count[22]} {send_results/count[23]} {send_results/count[24]} {send_results/count[25]} {send_results/count[26]} {send_results/count[27]} {send_results/count[28]} {send_results/count[29]} {send_results/count[30]} {send_results/count[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list eeprom/eeprom_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list eeprom/trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list send_results/tx_data_enb]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[0]]
