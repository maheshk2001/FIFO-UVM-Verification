class fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
	`uvm_component_utils(fifo_sequencer)
	
	function new(string path = "fifo_sequencer", uvm_component parent);
		super.new(path,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
endclass : fifo_sequencer