##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source trig_vio.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project zubpm_hw zubpm_hw -part xc7a200tfbg484-2
  set_property target_language VHDL [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:vio:3.0 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP trig_vio
##################################################################

set trig_vio [create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name trig_vio]

# User Parameters
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {0} \
  CONFIG.C_NUM_PROBE_OUT {17} \
  CONFIG.C_PROBE_OUT10_WIDTH {32} \
  CONFIG.C_PROBE_OUT11_WIDTH {32} \
  CONFIG.C_PROBE_OUT12_WIDTH {32} \
  CONFIG.C_PROBE_OUT13_WIDTH {32} \
  CONFIG.C_PROBE_OUT14_WIDTH {32} \
  CONFIG.C_PROBE_OUT15_WIDTH {32} \
  CONFIG.C_PROBE_OUT16_WIDTH {32} \
  CONFIG.C_PROBE_OUT1_WIDTH {32} \
  CONFIG.C_PROBE_OUT2_WIDTH {32} \
  CONFIG.C_PROBE_OUT3_WIDTH {32} \
  CONFIG.C_PROBE_OUT4_WIDTH {32} \
  CONFIG.C_PROBE_OUT5_WIDTH {32} \
  CONFIG.C_PROBE_OUT6_WIDTH {32} \
  CONFIG.C_PROBE_OUT7_WIDTH {32} \
  CONFIG.C_PROBE_OUT8_WIDTH {32} \
  CONFIG.C_PROBE_OUT9_WIDTH {32} \
] [get_ips trig_vio]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $trig_vio

##################################################################

