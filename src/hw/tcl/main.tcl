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

  
  lappend Sources {"../hdl/top.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/acmi_package.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/ACMI_tpg.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/adc_interface.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/adc_readout_test.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/backend_comm_wrapper.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/calc_baseline.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/calc_charge.vhd" "VHDL 2008"}    
  lappend Sources {"../hdl/calc_fwhm.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/calc_integ.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/calc_peak.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/calc_stats.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/eeprom.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/eeprom_interface.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/gen_timing_events.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/pulse_gen.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/trig_pulse.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/rx_kria_data.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/sampnum.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/sfp_gtp.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/stretch.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/tx_kria_data.vhd" "VHDL 2008"}
  
  lappend Sources {"../hdl/gtp/gtwizard_0_clock_module.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/gtp/gtwizard_0_common.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/gtp/gtwizard_0_common_reset.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/gtp/gtwizard_0_cpll_railing.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/gtp/gtwizard_0_gt_usrclk_source.vhd" "VHDL 2008"}
  lappend Sources {"../hdl/gtp/gtwizard_0_support.vhd" "VHDL 2008"}                                                                       

  lappend Sources {"../cstr/pins.xdc"  "XDC"} 
  lappend Sources {"../cstr/gtp.xdc"  "XDC"}     
  #lappend Sources {"../cstr/timing.xdc"  "XDC"} 
  #lappend Sources {"../cstr/debug.xdc"  "XDC"} 
  
  
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
   
  
  source ${TclPath}/adc_fifo.tcl
  source ${TclPath}/blk_mem_gen_0.tcl
  source ${TclPath}/clk_wiz_0.tcl
  source ${TclPath}/c_shift_ram_0.tcl
  source ${TclPath}/gtwizard_0.tcl
  source ${TclPath}/tx_fifo.tcl
  

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
