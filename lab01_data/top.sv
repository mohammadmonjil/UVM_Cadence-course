/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
// import the UVM library
// include the UVM macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    // import the YAPP package
    import yapp_pkg::*;
    // generate 5 random packets and use the print method
    // to display the results
    
    yapp_packet packet, copy_packet, clone_packet;
    
    initial begin
        copy_packet = new("copy_packet");
        
        for(int i=0; i<5; i++) begin
            packet = new( $sformatf("packet_%0d",i) );
            packet.randomize();
            packet.print();
        end
        
        $display("\n********Printers");
        packet.print(uvm_default_line_printer);
        copy_packet.copy(packet);
        copy_packet.print();
        
        $cast(clone_packet, packet.clone());
        
        $display("\n Comparing with copy");
        copy_packet.compare(packet);
        $display("\n Comparing with clone");
        clone_packet.compare(packet);
        
        packet.randomize();
        $display("\n Comparing after randomize");
        copy_packet.compare(packet);
    end

// experiment with the copy, clone and compare UVM method
endmodule : top
