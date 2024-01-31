import uvm_pkg::*;
`include "uvm_macros.svh"

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MSG", "Test bench Build phase executing", UVM_HIGH)
    endfunction
    

endclass : router_tb