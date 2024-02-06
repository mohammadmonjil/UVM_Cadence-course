/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  int ok;
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

class yapp_6_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_6_packets)

  // Constructor
  function new(string name="yapp_6_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_6_packets sequence", UVM_LOW)
     repeat(6)
      `uvm_do(req)
  endtask
  
endclass : yapp_6_packets


class yapp_1_seq extends yapp_base_seq; 
  `uvm_object_utils(yapp_1_seq)

  // Constructor
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq", UVM_LOW) 
    `uvm_do_with(req,{req.addr==1;})
  endtask

endclass: yapp_1_seq

class yapp_012_seq extends yapp_base_seq; 
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq", UVM_LOW) 
    `uvm_do_with(req,{req.addr==0;})
    `uvm_do_with(req,{req.addr==1;})
    `uvm_do_with(req,{req.addr==2;})
  endtask

endclass: yapp_012_seq


class yapp_88_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_88_seq)

  // Constructor
  function new(string name="yapp_88_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_88_seq", UVM_LOW) 
    `uvm_create(req)
    req.packet_delay = 1;
    for(int i = 0; i< 4; i = i+1)
    begin
      req.addr = i;
      for(int j = 1; j < 23; j = j+1)
      begin
        req.length = j;
        req.payload = new[j];
        for (int k = 0; k < j; k = k+1)
          req.payload[k] = k;
        randcase
          20: req.parity_type = BAD_PARITY;
          80: req.parity_type = GOOD_PARITY;
        endcase

        req.set_parity();
        `uvm_send(req)

        //  $display("Creating packet with addr = %d & length = %d", i,j);
        // if (i==3) begin
        //   `uvm_create(req)
        //   ok = req.randomize() with {req.length == j;};
        //   if(!ok)
        //     `uvm_error("ERR","Randomization failed.")
        //   req.addr = i;
        //   req.set_parity();
        //   `uvm_send(req)
        // end
        // else
        //   `uvm_do_with(req,{req.addr==i;req.length==j;})
        
      end
    end

  endtask

endclass: yapp_88_seq


class yapp_111_seq extends yapp_base_seq; 
  `uvm_object_utils(yapp_111_seq)

  // Constructor
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  yapp_1_seq ysa;
  // Sequence body definition
  
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq", UVM_LOW) 
    repeat(3)
      `uvm_do(ysa)
  endtask

endclass: yapp_111_seq

class yapp_incr_payload_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_incr_payload_seq)

  // Constructor
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction
  int ok;
  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq", UVM_LOW) 
    `uvm_create(req)
    ok = req.randomize();
    for (int i = 0; i< req.length; i = i+1) begin
        req.payload[i] = i;  
    end
    req.set_parity();
    `uvm_send(req)

  endtask

endclass : yapp_incr_payload_seq

class yapp_repeat_addr_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_repeat_addr_seq)
    function new(string name = "yapp_repeat_addr_seq");
      super.new(name);
    endfunction
    
    rand bit[1:0] seqaddr;
    constraint c1 { seqaddr!= 2'b11; }; 

    virtual task body();
      `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq", UVM_LOW) 
      `uvm_do_with(req, {req.addr==seqaddr;})
      `uvm_do_with(req, {req.addr==seqaddr;})
    endtask
endclass: yapp_repeat_addr_seq


class yapp_exhaustive_seq extends yapp_base_seq;
    `uvm_object_utils(yapp_exhaustive_seq)
    function new(string name = "yapp_exhaustive_seq");
      super.new(name);
    endfunction
    
    yapp_1_seq y_1_seq;
    yapp_111_seq y_111_seq;
    yapp_012_seq y_012_seq;
    yapp_repeat_addr_seq y_repeat_addr_seq;

    virtual task body();

      `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq", UVM_LOW) 
      `uvm_do(y_1_seq)
      `uvm_do(y_111_seq)
      `uvm_do(y_012_seq)
      `uvm_do(y_repeat_addr_seq)

    endtask

endclass: yapp_exhaustive_seq