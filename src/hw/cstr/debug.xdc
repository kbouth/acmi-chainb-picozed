

connect_debug_port u_ila_0/clk [get_nets [list adc/adc_clk]]
connect_debug_port u_ila_0/probe0 [get_nets [list {adc_data[0]} {adc_data[1]} {adc_data[2]} {adc_data[3]} {adc_data[4]} {adc_data[5]} {adc_data[6]} {adc_data[7]} {adc_data[8]} {adc_data[9]} {adc_data[10]} {adc_data[11]} {adc_data[12]} {adc_data[13]} {adc_data[14]} {adc_data[15]}]]

connect_debug_port u_ila_0/clk [get_nets [list {dbg_OBUF_BUFG[0]}]]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF_BUFG[0]]




connect_debug_port u_ila_0/probe0 [get_nets [list {pzed_params[trig_out_delay][0]} {pzed_params[trig_out_delay][1]} {pzed_params[trig_out_delay][2]} {pzed_params[trig_out_delay][3]} {pzed_params[trig_out_delay][4]} {pzed_params[trig_out_delay][5]} {pzed_params[trig_out_delay][6]} {pzed_params[trig_out_delay][7]} {pzed_params[trig_out_delay][8]} {pzed_params[trig_out_delay][9]} {pzed_params[trig_out_delay][10]} {pzed_params[trig_out_delay][11]} {pzed_params[trig_out_delay][12]} {pzed_params[trig_out_delay][13]} {pzed_params[trig_out_delay][14]} {pzed_params[trig_out_delay][15]} {pzed_params[trig_out_delay][16]} {pzed_params[trig_out_delay][17]} {pzed_params[trig_out_delay][18]} {pzed_params[trig_out_delay][19]} {pzed_params[trig_out_delay][20]} {pzed_params[trig_out_delay][21]} {pzed_params[trig_out_delay][22]} {pzed_params[trig_out_delay][23]} {pzed_params[trig_out_delay][24]} {pzed_params[trig_out_delay][25]} {pzed_params[trig_out_delay][26]} {pzed_params[trig_out_delay][27]} {pzed_params[trig_out_delay][28]} {pzed_params[trig_out_delay][29]} {pzed_params[trig_out_delay][30]} {pzed_params[trig_out_delay][31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {eeprom/opcode[0]} {eeprom/opcode[1]} {eeprom/opcode[2]} {eeprom/opcode[3]} {eeprom/opcode[4]} {eeprom/opcode[5]} {eeprom/opcode[6]} {eeprom/opcode[7]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {eeprom/eeprom_state__0[0]} {eeprom/eeprom_state__0[1]} {eeprom/eeprom_state__0[2]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {eeprom/eeprom_state[0]} {eeprom/eeprom_state[1]} {eeprom/eeprom_state[2]}]]
connect_debug_port u_ila_0/probe59 [get_nets [list {eeprom/address[0]} {eeprom/address[1]} {eeprom/address[2]} {eeprom/address[3]} {eeprom/address[4]} {eeprom/address[5]} {eeprom/address[6]} {eeprom/address[7]} {eeprom/address[8]} {eeprom/address[9]} {eeprom/address[10]} {eeprom/address[11]} {eeprom/address[12]} {eeprom/address[13]} {eeprom/address[14]} {eeprom/address[15]}]]
connect_debug_port u_ila_0/probe64 [get_nets [list {spi_comm/sclk_sync[0]} {spi_comm/sclk_sync[1]} {spi_comm/sclk_sync[2]}]]
connect_debug_port u_ila_0/probe66 [get_nets [list {spi_comm/present_state[0]} {spi_comm/present_state[1]}]]
connect_debug_port u_ila_0/probe69 [get_nets [list {spi_comm/bit_count[0]} {spi_comm/bit_count[1]} {spi_comm/bit_count[2]} {spi_comm/bit_count[3]} {spi_comm/bit_count[4]} {spi_comm/bit_count[5]} {spi_comm/bit_count[6]} {spi_comm/bit_count[7]} {spi_comm/bit_count[8]} {spi_comm/bit_count[9]} {spi_comm/bit_count[10]} {spi_comm/bit_count[11]} {spi_comm/bit_count[12]} {spi_comm/bit_count[13]} {spi_comm/bit_count[14]} {spi_comm/bit_count[15]} {spi_comm/bit_count[16]} {spi_comm/bit_count[17]} {spi_comm/bit_count[18]} {spi_comm/bit_count[19]} {spi_comm/bit_count[20]} {spi_comm/bit_count[21]} {spi_comm/bit_count[22]} {spi_comm/bit_count[23]} {spi_comm/bit_count[24]} {spi_comm/bit_count[25]} {spi_comm/bit_count[26]} {spi_comm/bit_count[27]} {spi_comm/bit_count[28]} {spi_comm/bit_count[29]} {spi_comm/bit_count[30]} {spi_comm/bit_count[31]}]]
connect_debug_port u_ila_0/probe72 [get_nets [list spi_comm/csn_active]]
connect_debug_port u_ila_0/probe75 [get_nets [list eeprom/eeprom_rdy]]
connect_debug_port u_ila_0/probe76 [get_nets [list {pzed_params[accum_reset]}]]
connect_debug_port u_ila_0/probe79 [get_nets [list {pzed_params[trig_out_enable]}]]
connect_debug_port u_ila_0/probe81 [get_nets [list spi_comm/sclk_rise]]


connect_debug_port u_ila_0/probe9 [get_nets [list {eeprom/eeprom_params[crc32_calc][0]} {eeprom/eeprom_params[crc32_calc][1]} {eeprom/eeprom_params[crc32_calc][2]} {eeprom/eeprom_params[crc32_calc][3]} {eeprom/eeprom_params[crc32_calc][4]} {eeprom/eeprom_params[crc32_calc][5]} {eeprom/eeprom_params[crc32_calc][6]} {eeprom/eeprom_params[crc32_calc][7]} {eeprom/eeprom_params[crc32_calc][8]} {eeprom/eeprom_params[crc32_calc][9]} {eeprom/eeprom_params[crc32_calc][10]} {eeprom/eeprom_params[crc32_calc][11]} {eeprom/eeprom_params[crc32_calc][12]} {eeprom/eeprom_params[crc32_calc][13]} {eeprom/eeprom_params[crc32_calc][14]} {eeprom/eeprom_params[crc32_calc][15]} {eeprom/eeprom_params[crc32_calc][16]} {eeprom/eeprom_params[crc32_calc][17]} {eeprom/eeprom_params[crc32_calc][18]} {eeprom/eeprom_params[crc32_calc][19]} {eeprom/eeprom_params[crc32_calc][20]} {eeprom/eeprom_params[crc32_calc][21]} {eeprom/eeprom_params[crc32_calc][22]} {eeprom/eeprom_params[crc32_calc][23]} {eeprom/eeprom_params[crc32_calc][24]} {eeprom/eeprom_params[crc32_calc][25]} {eeprom/eeprom_params[crc32_calc][26]} {eeprom/eeprom_params[crc32_calc][27]} {eeprom/eeprom_params[crc32_calc][28]} {eeprom/eeprom_params[crc32_calc][29]} {eeprom/eeprom_params[crc32_calc][30]} {eeprom/eeprom_params[crc32_calc][31]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {eeprom/eeprom_params[beam_adc_delay][0]} {eeprom/eeprom_params[beam_adc_delay][1]} {eeprom/eeprom_params[beam_adc_delay][2]} {eeprom/eeprom_params[beam_adc_delay][3]} {eeprom/eeprom_params[beam_adc_delay][4]} {eeprom/eeprom_params[beam_adc_delay][5]} {eeprom/eeprom_params[beam_adc_delay][6]} {eeprom/eeprom_params[beam_adc_delay][7]} {eeprom/eeprom_params[beam_adc_delay][8]} {eeprom/eeprom_params[beam_adc_delay][9]} {eeprom/eeprom_params[beam_adc_delay][10]} {eeprom/eeprom_params[beam_adc_delay][11]} {eeprom/eeprom_params[beam_adc_delay][12]} {eeprom/eeprom_params[beam_adc_delay][13]} {eeprom/eeprom_params[beam_adc_delay][14]} {eeprom/eeprom_params[beam_adc_delay][15]} {eeprom/eeprom_params[beam_adc_delay][16]} {eeprom/eeprom_params[beam_adc_delay][17]} {eeprom/eeprom_params[beam_adc_delay][18]} {eeprom/eeprom_params[beam_adc_delay][19]} {eeprom/eeprom_params[beam_adc_delay][20]} {eeprom/eeprom_params[beam_adc_delay][21]} {eeprom/eeprom_params[beam_adc_delay][22]} {eeprom/eeprom_params[beam_adc_delay][23]} {eeprom/eeprom_params[beam_adc_delay][24]} {eeprom/eeprom_params[beam_adc_delay][25]} {eeprom/eeprom_params[beam_adc_delay][26]} {eeprom/eeprom_params[beam_adc_delay][27]} {eeprom/eeprom_params[beam_adc_delay][28]} {eeprom/eeprom_params[beam_adc_delay][29]} {eeprom/eeprom_params[beam_adc_delay][30]} {eeprom/eeprom_params[beam_adc_delay][31]}]]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list adc/adc_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {send_results/present_state[0]} {send_results/present_state[1]} {send_results/present_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {send_results/tx_data[0]} {send_results/tx_data[1]} {send_results/tx_data[2]} {send_results/tx_data[3]} {send_results/tx_data[4]} {send_results/tx_data[5]} {send_results/tx_data[6]} {send_results/tx_data[7]} {send_results/tx_data[8]} {send_results/tx_data[9]} {send_results/tx_data[10]} {send_results/tx_data[11]} {send_results/tx_data[12]} {send_results/tx_data[13]} {send_results/tx_data[14]} {send_results/tx_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {calc_q/beam/present_state[0]} {calc_q/beam/present_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {calc_q/beam/gate_start[0]} {calc_q/beam/gate_start[1]} {calc_q/beam/gate_start[2]} {calc_q/beam/gate_start[3]} {calc_q/beam/gate_start[4]} {calc_q/beam/gate_start[5]} {calc_q/beam/gate_start[6]} {calc_q/beam/gate_start[7]} {calc_q/beam/gate_start[8]} {calc_q/beam/gate_start[9]} {calc_q/beam/gate_start[10]} {calc_q/beam/gate_start[11]} {calc_q/beam/gate_start[12]} {calc_q/beam/gate_start[13]} {calc_q/beam/gate_start[14]} {calc_q/beam/gate_start[15]} {calc_q/beam/gate_start[16]} {calc_q/beam/gate_start[17]} {calc_q/beam/gate_start[18]} {calc_q/beam/gate_start[19]} {calc_q/beam/gate_start[20]} {calc_q/beam/gate_start[21]} {calc_q/beam/gate_start[22]} {calc_q/beam/gate_start[23]} {calc_q/beam/gate_start[24]} {calc_q/beam/gate_start[25]} {calc_q/beam/gate_start[26]} {calc_q/beam/gate_start[27]} {calc_q/beam/gate_start[28]} {calc_q/beam/gate_start[29]} {calc_q/beam/gate_start[30]} {calc_q/beam/gate_start[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {boxcar/accum[0]} {boxcar/accum[1]} {boxcar/accum[2]} {boxcar/accum[3]} {boxcar/accum[4]} {boxcar/accum[5]} {boxcar/accum[6]} {boxcar/accum[7]} {boxcar/accum[8]} {boxcar/accum[9]} {boxcar/accum[10]} {boxcar/accum[11]} {boxcar/accum[12]} {boxcar/accum[13]} {boxcar/accum[14]} {boxcar/accum[15]} {boxcar/accum[16]} {boxcar/accum[17]} {boxcar/accum[18]} {boxcar/accum[19]} {boxcar/accum[20]} {boxcar/accum[21]} {boxcar/accum[22]} {boxcar/accum[23]} {boxcar/accum[24]} {boxcar/accum[25]} {boxcar/accum[26]} {boxcar/accum[27]} {boxcar/accum[28]} {boxcar/accum[29]} {boxcar/accum[30]} {boxcar/accum[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 13 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {boxcar/wr_ptr[0]} {boxcar/wr_ptr[1]} {boxcar/wr_ptr[2]} {boxcar/wr_ptr[3]} {boxcar/wr_ptr[4]} {boxcar/wr_ptr[5]} {boxcar/wr_ptr[6]} {boxcar/wr_ptr[7]} {boxcar/wr_ptr[8]} {boxcar/wr_ptr[9]} {boxcar/wr_ptr[10]} {boxcar/wr_ptr[11]} {boxcar/wr_ptr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {boxcar/q_min[0]} {boxcar/q_min[1]} {boxcar/q_min[2]} {boxcar/q_min[3]} {boxcar/q_min[4]} {boxcar/q_min[5]} {boxcar/q_min[6]} {boxcar/q_min[7]} {boxcar/q_min[8]} {boxcar/q_min[9]} {boxcar/q_min[10]} {boxcar/q_min[11]} {boxcar/q_min[12]} {boxcar/q_min[13]} {boxcar/q_min[14]} {boxcar/q_min[15]} {boxcar/q_min[16]} {boxcar/q_min[17]} {boxcar/q_min[18]} {boxcar/q_min[19]} {boxcar/q_min[20]} {boxcar/q_min[21]} {boxcar/q_min[22]} {boxcar/q_min[23]} {boxcar/q_min[24]} {boxcar/q_min[25]} {boxcar/q_min[26]} {boxcar/q_min[27]} {boxcar/q_min[28]} {boxcar/q_min[29]} {boxcar/q_min[30]} {boxcar/q_min[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 3 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {boxcar/present_state[0]} {boxcar/present_state[1]} {boxcar/present_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 13 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {boxcar/rd_ptr[0]} {boxcar/rd_ptr[1]} {boxcar/rd_ptr[2]} {boxcar/rd_ptr[3]} {boxcar/rd_ptr[4]} {boxcar/rd_ptr[5]} {boxcar/rd_ptr[6]} {boxcar/rd_ptr[7]} {boxcar/rd_ptr[8]} {boxcar/rd_ptr[9]} {boxcar/rd_ptr[10]} {boxcar/rd_ptr[11]} {boxcar/rd_ptr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 17 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {calc_q/pulse_stats[0][peak][0]} {calc_q/pulse_stats[0][peak][1]} {calc_q/pulse_stats[0][peak][2]} {calc_q/pulse_stats[0][peak][3]} {calc_q/pulse_stats[0][peak][4]} {calc_q/pulse_stats[0][peak][5]} {calc_q/pulse_stats[0][peak][6]} {calc_q/pulse_stats[0][peak][7]} {calc_q/pulse_stats[0][peak][8]} {calc_q/pulse_stats[0][peak][9]} {calc_q/pulse_stats[0][peak][10]} {calc_q/pulse_stats[0][peak][11]} {calc_q/pulse_stats[0][peak][12]} {calc_q/pulse_stats[0][peak][13]} {calc_q/pulse_stats[0][peak][14]} {calc_q/pulse_stats[0][peak][15]} {calc_q/pulse_stats[0][peak][16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {calc_q/pulse_stats[0][integral][0]} {calc_q/pulse_stats[0][integral][1]} {calc_q/pulse_stats[0][integral][2]} {calc_q/pulse_stats[0][integral][3]} {calc_q/pulse_stats[0][integral][4]} {calc_q/pulse_stats[0][integral][5]} {calc_q/pulse_stats[0][integral][6]} {calc_q/pulse_stats[0][integral][7]} {calc_q/pulse_stats[0][integral][8]} {calc_q/pulse_stats[0][integral][9]} {calc_q/pulse_stats[0][integral][10]} {calc_q/pulse_stats[0][integral][11]} {calc_q/pulse_stats[0][integral][12]} {calc_q/pulse_stats[0][integral][13]} {calc_q/pulse_stats[0][integral][14]} {calc_q/pulse_stats[0][integral][15]} {calc_q/pulse_stats[0][integral][16]} {calc_q/pulse_stats[0][integral][17]} {calc_q/pulse_stats[0][integral][18]} {calc_q/pulse_stats[0][integral][19]} {calc_q/pulse_stats[0][integral][20]} {calc_q/pulse_stats[0][integral][21]} {calc_q/pulse_stats[0][integral][22]} {calc_q/pulse_stats[0][integral][23]} {calc_q/pulse_stats[0][integral][24]} {calc_q/pulse_stats[0][integral][25]} {calc_q/pulse_stats[0][integral][26]} {calc_q/pulse_stats[0][integral][27]} {calc_q/pulse_stats[0][integral][28]} {calc_q/pulse_stats[0][integral][29]} {calc_q/pulse_stats[0][integral][30]} {calc_q/pulse_stats[0][integral][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {calc_q/pulse_stats[0][peak_index][0]} {calc_q/pulse_stats[0][peak_index][1]} {calc_q/pulse_stats[0][peak_index][2]} {calc_q/pulse_stats[0][peak_index][3]} {calc_q/pulse_stats[0][peak_index][4]} {calc_q/pulse_stats[0][peak_index][5]} {calc_q/pulse_stats[0][peak_index][6]} {calc_q/pulse_stats[0][peak_index][7]} {calc_q/pulse_stats[0][peak_index][8]} {calc_q/pulse_stats[0][peak_index][9]} {calc_q/pulse_stats[0][peak_index][10]} {calc_q/pulse_stats[0][peak_index][11]} {calc_q/pulse_stats[0][peak_index][12]} {calc_q/pulse_stats[0][peak_index][13]} {calc_q/pulse_stats[0][peak_index][14]} {calc_q/pulse_stats[0][peak_index][15]} {calc_q/pulse_stats[0][peak_index][16]} {calc_q/pulse_stats[0][peak_index][17]} {calc_q/pulse_stats[0][peak_index][18]} {calc_q/pulse_stats[0][peak_index][19]} {calc_q/pulse_stats[0][peak_index][20]} {calc_q/pulse_stats[0][peak_index][21]} {calc_q/pulse_stats[0][peak_index][22]} {calc_q/pulse_stats[0][peak_index][23]} {calc_q/pulse_stats[0][peak_index][24]} {calc_q/pulse_stats[0][peak_index][25]} {calc_q/pulse_stats[0][peak_index][26]} {calc_q/pulse_stats[0][peak_index][27]} {calc_q/pulse_stats[0][peak_index][28]} {calc_q/pulse_stats[0][peak_index][29]} {calc_q/pulse_stats[0][peak_index][30]} {calc_q/pulse_stats[0][peak_index][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 16 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {calc_q/pulse_stats[0][fwhm][0]} {calc_q/pulse_stats[0][fwhm][1]} {calc_q/pulse_stats[0][fwhm][2]} {calc_q/pulse_stats[0][fwhm][3]} {calc_q/pulse_stats[0][fwhm][4]} {calc_q/pulse_stats[0][fwhm][5]} {calc_q/pulse_stats[0][fwhm][6]} {calc_q/pulse_stats[0][fwhm][7]} {calc_q/pulse_stats[0][fwhm][8]} {calc_q/pulse_stats[0][fwhm][9]} {calc_q/pulse_stats[0][fwhm][10]} {calc_q/pulse_stats[0][fwhm][11]} {calc_q/pulse_stats[0][fwhm][12]} {calc_q/pulse_stats[0][fwhm][13]} {calc_q/pulse_stats[0][fwhm][14]} {calc_q/pulse_stats[0][fwhm][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 16 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {calc_q/pulse_stats[0][baseline][0]} {calc_q/pulse_stats[0][baseline][1]} {calc_q/pulse_stats[0][baseline][2]} {calc_q/pulse_stats[0][baseline][3]} {calc_q/pulse_stats[0][baseline][4]} {calc_q/pulse_stats[0][baseline][5]} {calc_q/pulse_stats[0][baseline][6]} {calc_q/pulse_stats[0][baseline][7]} {calc_q/pulse_stats[0][baseline][8]} {calc_q/pulse_stats[0][baseline][9]} {calc_q/pulse_stats[0][baseline][10]} {calc_q/pulse_stats[0][baseline][11]} {calc_q/pulse_stats[0][baseline][12]} {calc_q/pulse_stats[0][baseline][13]} {calc_q/pulse_stats[0][baseline][14]} {calc_q/pulse_stats[0][baseline][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {send_results/count[0]} {send_results/count[1]} {send_results/count[2]} {send_results/count[3]} {send_results/count[4]} {send_results/count[5]} {send_results/count[6]} {send_results/count[7]} {send_results/count[8]} {send_results/count[9]} {send_results/count[10]} {send_results/count[11]} {send_results/count[12]} {send_results/count[13]} {send_results/count[14]} {send_results/count[15]} {send_results/count[16]} {send_results/count[17]} {send_results/count[18]} {send_results/count[19]} {send_results/count[20]} {send_results/count[21]} {send_results/count[22]} {send_results/count[23]} {send_results/count[24]} {send_results/count[25]} {send_results/count[26]} {send_results/count[27]} {send_results/count[28]} {send_results/count[29]} {send_results/count[30]} {send_results/count[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 16 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {adc_data[0]} {adc_data[1]} {adc_data[2]} {adc_data[3]} {adc_data[4]} {adc_data[5]} {adc_data[6]} {adc_data[7]} {adc_data[8]} {adc_data[9]} {adc_data[10]} {adc_data[11]} {adc_data[12]} {adc_data[13]} {adc_data[14]} {adc_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 13 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {boxcar/accum_len[0]} {boxcar/accum_len[1]} {boxcar/accum_len[2]} {boxcar/accum_len[3]} {boxcar/accum_len[4]} {boxcar/accum_len[5]} {boxcar/accum_len[6]} {boxcar/accum_len[7]} {boxcar/accum_len[8]} {boxcar/accum_len[9]} {boxcar/accum_len[10]} {boxcar/accum_len[11]} {boxcar/accum_len[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 13 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {boxcar/buffcnt[0]} {boxcar/buffcnt[1]} {boxcar/buffcnt[2]} {boxcar/buffcnt[3]} {boxcar/buffcnt[4]} {boxcar/buffcnt[5]} {boxcar/buffcnt[6]} {boxcar/buffcnt[7]} {boxcar/buffcnt[8]} {boxcar/buffcnt[9]} {boxcar/buffcnt[10]} {boxcar/buffcnt[11]} {boxcar/buffcnt[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {boxcar/cnt[0]} {boxcar/cnt[1]} {boxcar/cnt[2]} {boxcar/cnt[3]} {boxcar/cnt[4]} {boxcar/cnt[5]} {boxcar/cnt[6]} {boxcar/cnt[7]} {boxcar/cnt[8]} {boxcar/cnt[9]} {boxcar/cnt[10]} {boxcar/cnt[11]} {boxcar/cnt[12]} {boxcar/cnt[13]} {boxcar/cnt[14]} {boxcar/cnt[15]} {boxcar/cnt[16]} {boxcar/cnt[17]} {boxcar/cnt[18]} {boxcar/cnt[19]} {boxcar/cnt[20]} {boxcar/cnt[21]} {boxcar/cnt[22]} {boxcar/cnt[23]} {boxcar/cnt[24]} {boxcar/cnt[25]} {boxcar/cnt[26]} {boxcar/cnt[27]} {boxcar/cnt[28]} {boxcar/cnt[29]} {boxcar/cnt[30]} {boxcar/cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {boxcar/new_samp[0]} {boxcar/new_samp[1]} {boxcar/new_samp[2]} {boxcar/new_samp[3]} {boxcar/new_samp[4]} {boxcar/new_samp[5]} {boxcar/new_samp[6]} {boxcar/new_samp[7]} {boxcar/new_samp[8]} {boxcar/new_samp[9]} {boxcar/new_samp[10]} {boxcar/new_samp[11]} {boxcar/new_samp[12]} {boxcar/new_samp[13]} {boxcar/new_samp[14]} {boxcar/new_samp[15]} {boxcar/new_samp[16]} {boxcar/new_samp[17]} {boxcar/new_samp[18]} {boxcar/new_samp[19]} {boxcar/new_samp[20]} {boxcar/new_samp[21]} {boxcar/new_samp[22]} {boxcar/new_samp[23]} {boxcar/new_samp[24]} {boxcar/new_samp[25]} {boxcar/new_samp[26]} {boxcar/new_samp[27]} {boxcar/new_samp[28]} {boxcar/new_samp[29]} {boxcar/new_samp[30]} {boxcar/new_samp[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 32 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {boxcar/old_samp[0]} {boxcar/old_samp[1]} {boxcar/old_samp[2]} {boxcar/old_samp[3]} {boxcar/old_samp[4]} {boxcar/old_samp[5]} {boxcar/old_samp[6]} {boxcar/old_samp[7]} {boxcar/old_samp[8]} {boxcar/old_samp[9]} {boxcar/old_samp[10]} {boxcar/old_samp[11]} {boxcar/old_samp[12]} {boxcar/old_samp[13]} {boxcar/old_samp[14]} {boxcar/old_samp[15]} {boxcar/old_samp[16]} {boxcar/old_samp[17]} {boxcar/old_samp[18]} {boxcar/old_samp[19]} {boxcar/old_samp[20]} {boxcar/old_samp[21]} {boxcar/old_samp[22]} {boxcar/old_samp[23]} {boxcar/old_samp[24]} {boxcar/old_samp[25]} {boxcar/old_samp[26]} {boxcar/old_samp[27]} {boxcar/old_samp[28]} {boxcar/old_samp[29]} {boxcar/old_samp[30]} {boxcar/old_samp[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {calc_q/pulse_stats[0][peak_found]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list send_results/tx_data_enb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list boxcar/wr_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[0]]
