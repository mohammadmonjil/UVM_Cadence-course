import uvm_pkg::*;
`include "uvm_macros.svh"
class base_test extends uvm_test;
   
    `uvm_component_utils(base_test)
    
    router_tb tb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        
        super.build_phase(phase);
        uvm_config_int::set( this, "*", "recording_detail", 1);
        
//        tb = new("tb", this);
        tb = router_tb::type_id::create("tb",this);
        `uvm_info("MSG", "Test build phase executing", UVM_HIGH)
    endfunction
    
    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology;
    endfunction
    
endclass : base_test

class short_packet_test extends base_test;
    
    `uvm_component_utils(short_packet_test)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                                 "default_sequence",
                                 yapp_5_packets::get_type());
        super.build_phase(phase);
        set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());
    endfunction
endclass : short_packet_test

class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)
    
//    router_tb tb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this,"tb.yapp.agent","is_active",UVM_PASSIVE);
//        tb = router_tb::type_id::create("tb",this);    
    endfunction
endclass: set_config_test