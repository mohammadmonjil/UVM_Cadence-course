class router_scoreboard extends uvm_scoreboard;
    
    int pkt_sent = 0;
    int wrong_pkts_channel_0 = 0;
    int wrong_pkts_channel_1 = 0;
    int wrong_pkts_channel_2 = 0; 
    int matched_pkts_channel_0 = 0;
    int matched_pkts_channel_1 = 0;
    int matched_pkts_channel_2 = 0;
    int rcvd_pkts_channel_0 = 0;
    int rcvd_pkts_channel_1 = 0;
    int rcvd_pkts_channel_2 = 0;

    yapp_packet addr_0_pkts[$], addr_1_pkts[$], addr_2_pkts[$]; //queues to store packets coming from yapp monitor

    `uvm_component_utils(router_scoreboard)
    
    // declare macros for different analysis_imp ports from yapp and channels
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_chan0)
    `uvm_analysis_imp_decl(_chan1)
    `uvm_analysis_imp_decl(_chan2)

    uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_in;
    uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;
    uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;
    uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        chan0_in = new("chan0_in", this);
        chan1_in = new("chan1_in", this);
        chan2_in = new("chan2_in", this);
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD",$sformatf("Total Packets Sent= %0d, Matched packet= %0d,  Wrong Packets = %0d", pkt_sent, matched_pkts_channel_0+matched_pkts_channel_1+matched_pkts_channel_2, wrong_pkts_channel_0+wrong_pkts_channel_1+wrong_pkts_channel_2), UVM_LOW)
        `uvm_info("SCOREBOARD",$sformatf("Channel 0 Received Packets = %0d, Matched packet= %0d,  Wrong Packets = %0d", rcvd_pkts_channel_0, matched_pkts_channel_0, wrong_pkts_channel_0), UVM_LOW)
        `uvm_info("SCOREBOARD",$sformatf("Channel 1 Received Packets = %0d, Matched packet= %0d,  Wrong Packets = %0d", rcvd_pkts_channel_1, matched_pkts_channel_1, wrong_pkts_channel_1), UVM_LOW)
        `uvm_info("SCOREBOARD",$sformatf("Channel 2 Received Packets = %0d, Matched packet= %0d,  Wrong Packets = %0d", rcvd_pkts_channel_2, matched_pkts_channel_2, wrong_pkts_channel_2), UVM_LOW)
        `uvm_info("SCOREBOARD",$sformatf("Packets left in queue= %0d", (addr_0_pkts.size()+ addr_1_pkts.size()+addr_2_pkts.size())), UVM_LOW)
    endfunction

    // write functions for the anaylsis imp ports
    function void write_yapp( yapp_packet pkt);
        yapp_packet pkt_tmp;
        $cast(pkt_tmp, pkt.clone());

        //send packets to appropriate queue based on the packet address
        case (pkt_tmp.addr)
            2'b00: addr_0_pkts.push_back(pkt_tmp);
            2'b01: addr_1_pkts.push_back(pkt_tmp);
            2'b10: addr_2_pkts.push_back(pkt_tmp);
            default: `uvm_info(get_type_name(), $sformatf("Packet dropped: Bad Address=%d\n%s",pkt_tmp.addr,pkt_tmp.sprint()), UVM_LOW)
        endcase
        pkt_sent++;
    endfunction

    function void write_chan0(channel_packet cp);
        yapp_packet yp;

        yp = addr_0_pkts.pop_front();
        
        if(comp_equal(yp,cp)) 
            matched_pkts_channel_0++;
        else
            wrong_pkts_channel_0++;
        
        rcvd_pkts_channel_0++;
    endfunction

    function void write_chan1(channel_packet cp);
        yapp_packet yp;

        yp = addr_1_pkts.pop_front();
        
        if(comp_equal(yp,cp)) 
            matched_pkts_channel_1++;
        else
            wrong_pkts_channel_1++;

        rcvd_pkts_channel_1++;
    endfunction

    function void write_chan2(channel_packet cp);
        yapp_packet yp;

        yp = addr_2_pkts.pop_front();
        
        if(comp_equal(yp,cp)) 
            matched_pkts_channel_2++;
        else
            wrong_pkts_channel_2++;

        rcvd_pkts_channel_2++;
    endfunction

    // function to compare input packet and output packet
    function bit comp_equal (yapp_packet yp, channel_packet cp);
        // returns first mismatch only
        if (yp.addr != cp.addr) begin
            `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
            return(0);
        end
        if (yp.length != cp.length) begin
            `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
            return(0);
        end
        foreach (yp.payload [i])
            if (yp.payload[i] != cp.payload[i]) begin
                `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
                return(0);
        end
        if (yp.parity != cp.parity) begin
            `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
            return(0);
        end
        return(1);
    endfunction

endclass