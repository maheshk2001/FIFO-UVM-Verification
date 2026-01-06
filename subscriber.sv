import uvm_pkg::*
`include "uvm_macros.svh";

class subscriber extends uvm_subscriber#(fifo_sequence_item);
    `uvm_component_utils(subscriber)

    uvm_analysis_imp#(fifo_sequence_item,subscriber) subscriber_ap;
    fifo_sequence_item subsriber_item;

    covergroup fifo with function sample(fifo_sequence_item)

    function new(string path = "subscriber",uvm_component parent);
        super.new(path,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        subsriber_item = fifo_sequence_item::type_id::create("subscriber_item");
        subscriber_ap = new("subscriber_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SUBSRIBER","UVM Subscriber Connected.",UVM_NONE);
    endfunction

    function void write(fifo_sequence_item subscriber_item);

    endfunction
endclass