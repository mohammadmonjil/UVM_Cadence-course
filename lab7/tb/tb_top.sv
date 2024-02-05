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
    import hbus_pkg::*;
    import channel_pkg::*;
    import clock_and_reset_pkg::*;
    `include "router_tb.sv"
    `include "router_test_lib.sv"
    
    hw_top hw_top();
    
    initial begin
        uvm_top.set_report_verbosity_level(UVM_LOW);
        yapp_vif_config::set(null,"uvm_test_top.tb.yapp.tx_agent.*","vif",hw_top.in0);
        channel_vif_config::set(null,"uvm_test_top.tb.chan0.*","vif",hw_top.chan_0_if);
        channel_vif_config::set(null,"uvm_test_top.tb.chan1.*","vif",hw_top.chan_1_if);
        channel_vif_config::set(null,"uvm_test_top.tb.chan2.*","vif",hw_top.chan_2_if);
        clock_and_reset_vif_config::set(null,"uvm_test_top.tb.clock_and_reset.*","vif",hw_top.clock_and_reset_if);
        hbus_vif_config::set(null,"uvm_test_top.tb.hbus.*","vif",hw_top.hbus_if);
        run_test("uvc_integration_test");
    end

endmodule : tb_top
