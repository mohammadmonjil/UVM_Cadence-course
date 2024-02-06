class router_reference extends uvm_component;
    
    
    `uvm_component_utils(router_reference)
    
    // implementation ports to get data from yapp and hbus uvc
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)

    uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in_imp;
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in_imp;

    // ports to send valid packets to scoreboard
    uvm_analysis_port #(yapp_packet) yapp_out_port;

    //initialized to reset values of the router
    bit [7:0] maxpktsize_reg = 8'h3F;
    bit [7:0] router_en_reg = 1'b1;

    int packets_dropped = 0;
    int packets_forwarded = 0;
    int jumbo_pakcets = 0;
    int bad_addr_packets = 0;
    yapp_packet packet_tmp;
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        yapp_in_imp = new("yapp_in_imp", this);
        hbus_in_imp = new("hbus_in_imp", this);
        yapp_out_port = new("yapp_out_port", this);
    endfunction

    //write implementation for hbu
    function void write_hbus(hbus_transaction tr);
        `uvm_info(get_type_name(), $sformatf("Received hbus transaction:\n%s", tr.sprint()), UVM_MEDIUM)
        if(tr.hwr_rd == HBUS_WRITE) 
        begin
            case(tr.haddr)
                'h1000: maxpktsize_reg = tr.hdata;
                'h1001: router_en_reg = tr.hdata;
            endcase
        end
    endfunction

    function void write_yapp(yapp_packet packet);
        `uvm_info(get_type_name(), $sformatf("Received Input Yapp packet:\n%s",packet.sprint()), UVM_LOW)
        
        packet_tmp = new("packet_tmp");
        $cast(packet_tmp,packet.clone());
        // send packets to scoreboard if valid
        if(packet_tmp.addr==3) begin
            bad_addr_packets++;
            packets_dropped++;
        end
        else if ((packet_tmp.length <= maxpktsize_reg) && (router_en_reg!=0)) begin
            yapp_out_port.write(packet_tmp);
            packets_forwarded++;
            `uvm_info(get_type_name(),"Packet sent to Scoreboard", UVM_LOW)
        end
        else if ((packet_tmp.length > maxpktsize_reg) && (router_en_reg!=0)) begin
            jumbo_pakcets++;
            packets_dropped++;
            `uvm_info(get_type_name(),$sformatf("Packet Dropped [Oversized]-pkt size %h & maxsize %h",packet_tmp.length, maxpktsize_reg), UVM_LOW)
        end

        else if (router_en_reg == 0) begin
            packets_dropped++;
            `uvm_info(get_type_name(), "Packet dropped [DISABLED]", UVM_LOW)
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: Router Reference: Packet Statistics \n Packets Dropped %0d Packets Forwarded %0d Oversized Packets %0d", packets_dropped, packets_forwarded, jumbo_pakcets), UVM_LOW)
    endfunction

endclass : router_reference