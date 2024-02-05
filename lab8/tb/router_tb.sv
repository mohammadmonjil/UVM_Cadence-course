import uvm_pkg::*;
`include "uvm_macros.svh"

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)
    yapp_env yapp;
    channel_env chan0;
    channel_env chan1;
    channel_env chan2;
    clock_and_reset_env clock_and_reset;
    hbus_env hbus;
    router_mcsequencer router_mcseqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        yapp = new("yapp",this);
        `uvm_info("MSG", "Test bench Build phase executing", UVM_HIGH)
        yapp = yapp_env::type_id::create("yapp",this);

        uvm_config_int::set(this, "chan0", "channel_id", 0);
        chan0 = channel_env::type_id::create("chan0",this);

        uvm_config_int::set(this, "chan1", "channel_id", 1);
        chan1 = channel_env::type_id::create("chan1",this);

        uvm_config_int::set(this, "chan2", "channel_id", 2);
        chan2 = channel_env::type_id::create("chan2",this);
        
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        hbus = hbus_env::type_id::create("hbus", this);

        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset",this);

        
        router_mcseqr = router_mcsequencer::type_id::create("router_mcseqr", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        router_mcseqr.yapp_seqr = yapp.tx_agent.sequencer;
        router_mcseqr.hbus_master_seqr = hbus.masters[0].sequencer;
    endfunction

    

endclass : router_tb