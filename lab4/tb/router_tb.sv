import uvm_pkg::*;
`include "uvm_macros.svh"

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)
    yapp_env yapp;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        yapp = new("yapp",this);
        yapp = yapp_env::type_id::create("yapp",this);
        `uvm_info("MSG", "Test bench Build phase executing", UVM_HIGH)
    endfunction
    

endclass : router_tb