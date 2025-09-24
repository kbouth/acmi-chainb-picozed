


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





connect_debug_port u_ila_0/probe0 [get_nets [list {eeprom/opcode[0]} {eeprom/opcode[1]} {eeprom/opcode[2]} {eeprom/opcode[3]} {eeprom/opcode[4]} {eeprom/opcode[5]} {eeprom/opcode[6]} {eeprom/opcode[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {eeprom/rddata[0]} {eeprom/rddata[1]} {eeprom/rddata[2]} {eeprom/rddata[3]} {eeprom/rddata[4]} {eeprom/rddata[5]} {eeprom/rddata[6]} {eeprom/rddata[7]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {eeprom/eeprom_state__0[0]} {eeprom/eeprom_state__0[1]} {eeprom/eeprom_state__0[2]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {eeprom/eeprom_state[0]} {eeprom/eeprom_state[1]} {eeprom/eeprom_state[2]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list {eeprom/address[0]} {eeprom/address[1]} {eeprom/address[2]} {eeprom/address[3]} {eeprom/address[4]} {eeprom/address[5]} {eeprom/address[6]} {eeprom/address[7]} {eeprom/address[8]} {eeprom/address[9]} {eeprom/address[10]} {eeprom/address[11]} {eeprom/address[12]} {eeprom/address[13]} {eeprom/address[14]} {eeprom/address[15]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list eeprom/eeprom_rdy]]
connect_debug_port u_ila_0/probe18 [get_nets [list eeprom/trig]]


