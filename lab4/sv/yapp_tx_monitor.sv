import uvm_pkg::*;
`include "uvm_macros.svh"

class yapp_tx_monitor extends uvm_monitor;
    `uvm_component_utils(yapp_tx_monitor)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        `uvm_info("MSG", "In Monitor", UVM_LOW)
    endtask

endclass : yapp_tx_monitor
