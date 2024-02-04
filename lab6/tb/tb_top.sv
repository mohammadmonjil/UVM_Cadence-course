/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import yapp_pkg::*;

    
    hw_top hw_top();
    
    initial begin
        uvm_top.set_report_verbosity_level(UVM_FULL);
        yapp_vif_config::set(null,"uvm_test_top.tb.yapp.tx_agent.*","vif",hw_top.in0);
        run_test("short_yapp_012_test");
    end

endmodule : tb_top
