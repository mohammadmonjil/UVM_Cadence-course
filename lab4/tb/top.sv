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

    initial begin
        uvm_top.set_report_verbosity_level(UVM_LOW);
        run_test("short_packet_test");
    end

endmodule : top
