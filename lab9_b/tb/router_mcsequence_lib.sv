import uvm_pkg::*;
`include "uvm_macros.svh"

class router_simple_mcseq extends uvm_sequence;
    

    `uvm_object_utils(router_simple_mcseq)
    `uvm_declare_p_sequencer(router_mcsequencer)

    function new(string name = "router_simple_mcseq");
        super.new(name);
    endfunction

    virtual task pre_body();
        uvm_phase phase;
        phase = get_starting_phase();

        if (phase != null) begin
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    hbus_small_packet_seq hbus_sml_pkt_seq;
    hbus_read_max_pkt_seq hbus_rd_mx_pkt_seq;
    yapp_012_seq yapp_0_1_2_seq;
    hbus_set_default_regs_seq hbus_set_mx_pkt_64_seq;
    // yapp_packet yapp_pkt;
    yapp_6_packets yapp_6_pkt;

    virtual task body();
        `uvm_do_on(hbus_sml_pkt_seq, p_sequencer.hbus_master_seqr)
        `uvm_do_on(hbus_rd_mx_pkt_seq, p_sequencer.hbus_master_seqr)
        repeat(10)
            `uvm_do_on(yapp_0_1_2_seq, p_sequencer.yapp_seqr)
        `uvm_do_on(hbus_set_mx_pkt_64_seq, p_sequencer.hbus_master_seqr)
        `uvm_do_on(hbus_rd_mx_pkt_seq, p_sequencer.hbus_master_seqr)
        // repeat(6)
        //     `uvm_do_on(yapp_pkt, p_sequencer.yapp_seqr)
        `uvm_do_on(yapp_6_pkt, p_sequencer.yapp_seqr)
    endtask: body

    virtual task post_body();
        uvm_phase phase;
        phase = get_starting_phase();
        if (phase != null) begin
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body


endclass: router_simple_mcseq