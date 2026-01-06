class fifo_driver extends uvm_driver#(fifo_sequence_item);
	`uvm_component_utils(fifo_driver)
	
	virtual fifo_interface driver_interface;
	fifo_sequence_item fifo_driver_item;
	
	function new(string path = "fifo_driver", uvm_component parent);
		super.new(path,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db#(virtual fifo_interface)::get(this,"","interface",driver_interface)))
			`uvm_error("DRV","Failed to connect Driver Virtual Interface");
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			fifo_driver_item = fifo_sequence_item::type_id::create("fifo_driver item");
			seq_item_port.get_next_item(fifo_driver_item);
			drive (fifo_driver_item);
			seq_item_port.item_done();
		end
	endtask
	
	task drive(fifo_sequence_item drive_item);
		driver_interface.rstn <= drive_item.rstn;
		if (drive_item.rw == 0) begin
			driver_interface.w_cb.w_en <= 1'b0;
			@(driver_interface.r_cb);
				driver_interface.r_cb.r_en <= 1'b1;
			@(driver_interface.r_cb);
				driver_interface.r_cb.r_en <= 1'b0;
		end
		else if (drive_item.rw == 1) begin
			driver_interface.r_cb.r_en <= 1'b0;
			@(driver_interface.w_cb);
				driver_interface.w_cb.w_en <= 1'b1;
				driver_interface.w_cb.w_data <= drive_item.w_data;
			@(driver_interface.w_cb);
				driver_interface.w_cb.w_en <= 1'b0;
		end
	endtask : drive
endclass : fifo_driver
