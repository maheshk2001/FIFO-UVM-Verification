class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)
	
	fifo_agent agent_env;
	fifo_scoreboard sco_env;
	
	function new(string name = "fifo_env", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		agent_env = fifo_agent::type_id::create("agent_env",this);
		sco_env = fifo_scoreboard::type_id::create("sco_env",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		agent_env.mon_agent.monitor_ap.connect(sco_env.sb_mon_port);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask
endclass