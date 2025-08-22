ACMI Frontend Platform - Chain B

Gateware for ACMI Frontend.  Uses custom Artix board as the hardware platform.   Communicates with withe ACMI backend hardware via fiber.  Responsible for all ACMI related safety tasks 

Uses the DESY FWK FPGA Firmware Framework https://fpgafw.pages.desy.de/docs-pub/fwk/index.html

Clone with --recurse-submodules to get the FWK repos:

    git clone --recurse-submodules git@github.com:kbouth/acmi-chainb.git

Setup Environment (first time only): 
    
    make env

If error shows up, do this before make env:

    python3 -m venv env
    source env/bin/activate


To build firmware: 

     make cfg=hw project (Sets up project)
     
     make cfg=hw gui (Open in Vivado)
     
     make cfg=hw build (Builds bit file)
     
     make cfg=sw gui (Opens Vitis)
     
     make cfg=sw build (Builds Vitis program & boot file)

