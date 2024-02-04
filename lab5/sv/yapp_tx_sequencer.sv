import uvm_pkg::*;
`include "uvm_macros.svh"

class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);
    `uvm_component_utils(yapp_tx_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass : yapp_tx_sequencer