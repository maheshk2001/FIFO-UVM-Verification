
class fifo_agent extends uvm_agent;
	`uvm_component_utils(fifo_agent);
	
	fifo_sequencer seq_agent;
	fifo_monitor mon_agent;
	fifo_driver drv_agent;
	
	function new(string path = "fifo_agent",uvm_component parent );
		super.new(path,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq_agent = fifo_sequencer::type_id::create("seq_agent",this);
		mon_agent = fifo_monitor::type_id::create("mon_agent",this);
		drv_agent = fifo_driver::type_id::create("drv_agent",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		drv_agent.seq_item_port.connect(seq_agent.seq_item_export);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask
	
endclass
