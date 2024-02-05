import uvm_pkg::*;
`include "uvm_macros.svh"

class router_mcsequencer extends uvm_sequencer;
    
    yapp_tx_sequencer yapp_seqr;
    hbus_master_sequencer hbus_master_seqr;
    
    `uvm_component_utils(router_mcsequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("MSG","Creating router mcsequencer",UVM_LOW)
    endfunction


endclass: router_mcsequencer