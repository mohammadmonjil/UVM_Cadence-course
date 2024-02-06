import uvm_pkg::*;
`include "uvm_macros.svh"

class yapp_env extends uvm_env;
    `uvm_component_utils(yapp_env)
    yapp_tx_agent tx_agent;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        agent = new("agent", this);
        tx_agent = yapp_tx_agent::type_id::create("tx_agent",this);
    endfunction
    
endclass : yapp_env