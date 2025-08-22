################################################################################
# Main tcl for the module
################################################################################

# ==============================================================================
proc init {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl init()..."



}

# ==============================================================================
proc setSources {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl setSources()..."

  variable Sources 

  
  lappend Sources {"../hdl/top_tb.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/top.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/acmi_package.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/pwronreset.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/debounce.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/faults.vhd" "VHDL 2008"} 
  
  lappend Sources {"../hdl/gen_samplenum.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gen_startup_dly.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gen_test_pulses.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/gen_timestamp.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/gen_timing_events.vhd" "VHDL 2008"}     
  #lappend Sources {"../hdl/gen_trig_pulse.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/gen_window.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/beam_detect_window.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/pulse_gen.vhd" "VHDL 2008"}   
  
  lappend Sources {"../hdl/calc_charge.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/calc_beam_stats.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/calc_baseline.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/calc_fwhm.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/calc_integral.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/find_peak.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gen_gates.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/find_beam_oow.vhd" "VHDL 2008"}    
  lappend Sources {"../hdl/gen_gate.vhd" "VHDL 2008"} 
  
  lappend Sources {"../hdl/accumulator.vhd" "VHDL 2008"}  
  
  lappend Sources {"../hdl/i2c_monitors.vhd" "VHDL 2008"}
  
  lappend Sources {"../hdl/rx_backend_data.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/tx_backend_data.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/find_boow_pulse.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/beamoow_fifodata.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/faults_tp.vhd" "VHDL 2008"} 
  
  lappend Sources {"../hdl/eeprom_interface.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/eeprom_spi.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/crc_compute.vhd" "VHDL 2008"}     
  lappend Sources {"../hdl/crc32.vhd" "VHDL 2008"}   
  
  lappend Sources {"../hdl/adc_interface.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/read_ltc2107.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/ltc2107_spi.vhd" "VHDL 2008"}  
  
  lappend Sources {"../hdl/kria_comm_wrapper.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/align_rxdata.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gtp/kria_comm_support.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gtp/kria_comm_common_reset.vhd" "VHDL 2008"}     
  lappend Sources {"../hdl/gtp/kria_comm_gt_usrclk_source.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/gtp/kria_comm_clock_module.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/gtp/kria_comm_cpll_railing.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/gtp/kria_comm_common.vhd" "VHDL 2008"}        
  
  lappend Sources {"../hdl/stretch.vhd" "VHDL 2008"}  

  lappend Sources {"../cstr/pins.xdc"  "XDC"} 
  lappend Sources {"../cstr/gtp.xdc"  "XDC"}   
  lappend Sources {"../cstr/timing.xdc"  "XDC"}  
  lappend Sources {"../cstr/debug.xdc"  "XDC"}   
  
  
}

# ==============================================================================
proc setAddressSpace {} {
  # ::fwfwk::printCBM "In ./hw/src/main.tcl setAddressSpace()..."
  #variable AddressSpace
  
  #addAddressSpace AddressSpace "pl_regs"   RDL  {} ../rdl/pl_regs.rdl

}


# ==============================================================================
proc doOnCreate {} {
  # variable Vhdl
  variable TclPath

      
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnCreate()"
  set_property part             xc7a200tfbg484-2             [current_project]
  set_property target_language  VHDL                         [current_project]
  set_property default_lib      xil_defaultlib               [current_project]
   
  
  #source ${TclPath}/system.tcl
  #source ${TclPath}/evr_gth.tcl
  #source ${TclPath}/gth_artix.tcl
  #source ${TclPath}/gth_freerun_clk.tcl
  #source ${TclPath}/wvfm_fifo.tcl
  

  addSources "Sources" 
  
  ::fwfwk::printCBM "TclPath = ${TclPath}"
  ::fwfwk::printCBM "SrcPath = ${::fwfwk::SrcPath}"
  
  #set_property used_in_synthesis false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  #set_property used_in_implementation false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  
  #open_wave_config "${::fwfwk::SrcPath}/hw/sim/top_tb_behav.wcfg"
  

  
  
}

# ==============================================================================
proc doOnBuild {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnBuild()"



}


# ==============================================================================
proc setSim {} {
}
