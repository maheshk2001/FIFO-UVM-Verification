

class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor)
	
	virtual fifo_interface monitor_interface;
	fifo_sequence_item monitor_item;
	uvm_analysis_port#(fifo_sequence_item) monitor_ap;
	
	function new(string path = "fifo_monitor", uvm_component parent);
		super.new(path,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!(uvm_config_db#(virtual fifo_interface)::get(this,"*","interface",monitor_interface)))
			`uvm_fatal("MONITOR","Failed to get Interface");
		
		monitor_ap = new("monitor_ap",this);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
			fork
				forever begin
					// For write sequence item.
					@(monitor_interface.w_cb);
					if(monitor_interface.w_en) begin
						monitor_item = fifo_sequence_item::type_id::create("Write_item_monitor");
						monitor_item.rw = 1;
						monitor_item.w_data = monitor_interface.w_data;
						monitor_item.full_flag = monitor_interface.full_flag;
						monitor_item.rstn = monitor_interface.rstn;
						monitor_item.print_item("MONITOR");
						monitor_ap.write(monitor_item);
					end
				end

				forever begin 
					//For Read Sequence Item
					@(monitor_interface.r_cb);
					if(monitor_interface.r_en) begin
                      @(monitor_interface.r_cb);
						monitor_item = fifo_sequence_item::type_id::create("Read_item_monitor");
						monitor_item.rw = 0;
						monitor_item.r_data = monitor_interface.r_data;
						monitor_item.empty_flag = monitor_interface.empty_flag;
						monitor_item.rstn = monitor_interface.rstn;
						monitor_item.print_item("MONITOR");
						monitor_ap.write(monitor_item);
				end
				end
				
			join	
		
	endtask
	
endclass : fifo_monitor
