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

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask
    
endclass : base_test

class simple_test extends base_test;

    `uvm_component_utils(simple_test)
    
    router_tb tb;
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //set yapp default sequence
        uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());
        set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
        //set channel default sequence
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
        //set clock and reset default sequence
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
    endfunction

endclass: simple_test

class uvc_integration_test extends base_test;

    `uvm_component_utils(uvc_integration_test)
    
    router_tb tb;
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        

        //set yapp default sequence
        uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_88_seq::get_type());
        set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
        //set channel default sequence
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
        //set clock and reset default sequence
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
        //set hbus default sequence
        uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                                "default_sequence",
                                hbus_small_packet_seq::get_type());

        super.build_phase(phase);

    endfunction

endclass: uvc_integration_test

class multichannel_test extends base_test;

    `uvm_component_utils(multichannel_test)
    
    router_tb tb;

        
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        

        //set yapp default sequence
        // uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
        //                         "default_sequence",
        //                         yapp_88_seq::get_type());
        
        set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
        
        //set channel default sequence
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                                "default_sequence",
                                channel_rx_resp_seq::get_type());
        //set clock and reset default sequence
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                                "default_sequence",
                                clk10_rst5_seq::get_type());
        //set hbus default sequence
        // uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
        //                         "default_sequence",
        //                         hbus_small_packet_seq::get_type());

        uvm_config_wrapper::set(this, "tb.router_mcseqr.run_phase",
                                "default_sequence",
                                router_simple_mcseq::get_type());

        super.build_phase(phase);

    endfunction

endclass: multichannel_test

// class short_packet_test extends base_test;
    
//     `uvm_component_utils(short_packet_test)
    
//     function new(string name, uvm_component parent);
//         super.new(name,parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
//                                  "default_sequence",
//                                  yapp_5_packets::get_type());
//         super.build_phase(phase);
//         set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());
//     endfunction
// endclass : short_packet_test

// class set_config_test extends base_test;

//     `uvm_component_utils(set_config_test)
    
// //    router_tb tb;
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_int::set(this,"tb.yapp.tx_agent","is_active",UVM_PASSIVE);
// //        tb = router_tb::type_id::create("tb",this);    
//     endfunction
// endclass: set_config_test

// class incr_payload_test extends base_test;

//     `uvm_component_utils(incr_payload_test)
    
//    router_tb tb;
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
//                                  "default_sequence",
//                                  yapp_incr_payload_seq::get_type());
//         set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
//     endfunction
// endclass: incr_payload_test

// class yapp_111_seq_test extends base_test;

//     `uvm_component_utils(yapp_111_seq_test)
    
//    router_tb tb;
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
//                                  "default_sequence",
//                                  yapp_111_seq::get_type());
//         set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
//     endfunction
// endclass: yapp_111_seq_test

// class exhaustive_seq_test extends base_test;

//     `uvm_component_utils(exhaustive_seq_test)
    
//    router_tb tb;
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
//                                  "default_sequence",
//                                  yapp_exhaustive_seq::get_type());
//         set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
//     endfunction
// endclass: exhaustive_seq_test

// class short_yapp_012_test extends base_test;

//     `uvm_component_utils(short_yapp_012_test)
    
//    router_tb tb;
    
//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
    
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
//                                  "default_sequence",
//                                  yapp_012_seq::get_type());
//         set_type_override_by_type(yapp_packet::get_type(),short_yapp_packet::get_type());  
//     endfunction
// endclass: short_yapp_012_test

