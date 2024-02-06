import uvm_pkg::*;
`include "uvm_macros.svh"

class yapp_tx_monitor extends uvm_monitor;
    virtual interface yapp_if vif;
    yapp_packet pkt;
  // Count packets collected
    int num_pkt_col;
    // to send packets to scoreboard
    uvm_analysis_port #(yapp_packet) yapp_mon_analysis_port;

     `uvm_component_utils_begin(yapp_tx_monitor)
        `uvm_field_int(num_pkt_col,UVM_ALL_ON)
     `uvm_component_utils_end
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_mon_analysis_port = new("yapp_mon_analysis_port",this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        if(!yapp_vif_config::get(this,get_full_name(),"vif",vif))
            `uvm_error("NOVIF",{"vif is not set for: ",get_full_name(),".vif"})
    endfunction

    

    // UVM run() phase
    task run_phase(uvm_phase phase);
        // Look for packets after reset
        @(posedge vif.reset)
        @(negedge vif.reset)
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
        forever begin 
        // Create collected packet instance
        pkt = yapp_packet::type_id::create("pkt", this);

        // concurrent blocks for packet collection and transaction recording
        fork
            // collect packet
            vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
            // trigger transaction at start of packet
            @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
        join

        pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
        // End transaction recording
        end_tr(pkt);
        `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
        //send packets to scoreboard through analysis port
        yapp_mon_analysis_port.write(pkt);
        num_pkt_col++;
        end
    endtask : run_phase

    // UVM report_phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
    endfunction : report_phase
endclass : yapp_tx_monitor
