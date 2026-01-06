
//reset sequence
class fifo_reset_sequence extends uvm_sequence#(fifo_sequence_item);
	`uvm_object_utils(fifo_reset_sequence)
	
	function new (string path = "fifo_reset_sequence");
		super.new(path);
	endfunction 
	
	task body();
		fifo_sequence_item reset_item;
		reset_item = fifo_sequence_item::type_id::create("fifo_reset_sequence");
		reset_item.make_fifo_reset_item();
		start_item(reset_item);
		finish_item(reset_item);
	endtask : body
endclass : fifo_reset_sequence

//empty read sequence
class fifo_empty_read_sequence extends fifo_reset_sequence;
	`uvm_object_utils(fifo_empty_read_sequence)
	
	function new(string path = "fifo_empty_read_sequence");
		super.new(path);
	endfunction
	
	task body();
		super.body();
		
		repeat(5) begin
			fifo_sequence_item empty_read_item;
			empty_read_item = fifo_sequence_item::type_id::create("fifo_empty_read_sequence");
			assert(empty_read_item.randomize() with {rw == 0; rstn == 1;});
			start_item(empty_read_item);
			finish_item(empty_read_item);
		end
	endtask
endclass : fifo_empty_read_sequence

//Read after write sequence
class fifo_RAW_sequence extends uvm_sequence#(fifo_sequence_item);
	`uvm_object_utils(fifo_RAW_sequence)
		
	function new(string path = "fifo_RAW_sequence");
		super.new(path);
	endfunction
	
	task body();
		repeat(9) begin
			fifo_sequence_item W_seq_item;
			W_seq_item = fifo_sequence_item::type_id::create($sformatf("Write_item_%0d",get_sequence_id()));
			assert(W_seq_item.randomize() with {rw == 1;rstn==1;});
			start_item(W_seq_item);
			finish_item(W_seq_item);
		end
		
		repeat(9) begin
			fifo_sequence_item R_seq_item;
			R_seq_item = fifo_sequence_item::type_id::create($sformatf("Read_item_%0d",get_sequence_id()));
			assert(R_seq_item.randomize() with {rw == 0;rstn==1;});
			start_item(R_seq_item);
			finish_item(R_seq_item);
		end
	endtask
endclass : fifo_RAW_sequence

//random sequence
class fifo_random_sequence extends uvm_sequence#(fifo_sequence_item);
	`uvm_object_utils(fifo_random_sequence)
	
	function new(string path = "fifo_random_sequence");
		super.new(path);
	endfunction
	
	task body();
		
		repeat(15) begin
			fifo_sequence_item rand_seq_item;
			rand_seq_item = fifo_sequence_item::type_id::create($sformatf("Rand_item_%0d", get_sequence_id()));
			assert(rand_seq_item.randomize());
			start_item(rand_seq_item);
			finish_item(rand_seq_item);
		end
	endtask		
endclass : fifo_random_sequence

class fifo_full_sequence extends uvm_sequence#(fifo_sequence_item);
	`uvm_object_utils(fifo_full_sequence)
		
	function new(string path = "fifo_full_sequence");
		super.new(path);
	endfunction
	
	task body();
		fifo_sequence_item rst_item;
		rst_item = fifo_sequence_item::type_id::create("fifo_full_seq_rst");
		rst_item.make_fifo_reset_item();
		start_item(rst_item);
		finish_item(rst_item);
		repeat(16) begin
			fifo_sequence_item full_seq_item;
		    full_seq_item = fifo_sequence_item::type_id::create($sformatf("Full_seq_%0d",get_sequence_id()));
			assert(full_seq_item.randomize() with {rw==1;rstn == 1;});
			start_item(full_seq_item);
			finish_item(full_seq_item);
		end
	endtask
endclass :fifo_full_sequence

class fifo_overflow_sequence extends fifo_full_sequence;
	`uvm_object_utils(fifo_overflow_sequence)
	
	function new(string path = "fifo_overflow_sequence");
		super.new(path);
	endfunction
	
	task body();
		super.body();
		repeat(10)begin
			fifo_sequence_item W_seq_item;
			W_seq_item = fifo_sequence_item::type_id::create($sformatf("Overflow_Write_seq_%0d",get_sequence_id()));
			assert(W_seq_item.randomize() with {rw == 1;rstn == 1;})
			else
			`uvm_error("Overflow_sequence","Randomization Failed");
			start_item(W_seq_item);
			finish_item(W_seq_item);
		end
		repeat(16)begin
			fifo_sequence_item R_seq_item;
			R_seq_item = fifo_sequence_item::type_id::create($sformatf("Readafter_Overflow_seq_%0d",get_sequence_id()));
			assert(R_seq_item.randomize() with {rw == 0;rstn == 1;})
			else
			`uvm_error("Overflow_sequence","Randomization Failed");
			start_item(R_seq_item);
			finish_item(R_seq_item);
		end
	endtask
endclass : fifo_overflow_sequence

class fifo_zero_sequence extends uvm_sequence#(fifo_sequence_item);
	`uvm_object_utils(fifo_zero_sequence)
	
	function new(string path = "fifo_zero_sequence");
		super.new(path);
	endfunction
	
	task body();
		repeat(5)begin
			fifo_sequence_item W_Zero_seq_item;
			W_Zero_seq_item = fifo_sequence_item::type_id::create($sformatf("Zero_Write_seq_%0d",get_sequence_id()));
			W_Zero_seq_item.w_data_range.constraint_mode(0);
			assert(W_Zero_seq_item.randomize() with {w_data == 16'h0000;rw == 1;rstn == 1;})
			else
			`uvm_error("Zero_Write_sequence","Randomization Failed");
			start_item(W_Zero_seq_item);
			finish_item(W_Zero_seq_item);
		end
	endtask
endclass :fifo_zero_sequence

class fifo_one_sequence extends fifo_zero_sequence;
	`uvm_object_utils(fifo_one_sequence)
	
	function new(string path = "fifo_one_sequence");
		super.new(path);
	endfunction
	
	task body();
		super.body();
		
		repeat(5)begin
			fifo_sequence_item W_One_seq_item;
			W_One_seq_item = fifo_sequence_item::type_id::create($sformatf("One_Write_seq_%0d",get_sequence_id()));
			W_One_seq_item.w_data_range.constraint_mode(0);
			assert(W_One_seq_item.randomize() with {w_data == 16'hFFFF;rw == 1;rstn == 1;})
			else
			`uvm_error("One_Write_sequence","Randomization Failed");
			start_item(W_One_seq_item);
			finish_item(W_One_seq_item);
		end
	endtask
endclass : fifo_one_sequence

class fifo_ZeroOneR_sequence extends fifo_one_sequence;
	`uvm_object_utils(fifo_ZeroOneR_sequence)
	
	function new(string path = "fifo_ZeroOneR_Sequence");
		super.new(path);
	endfunction
	
	task body();
		super.body();
		
		repeat(10)begin
			fifo_sequence_item R_ZeroOne_seq_item;
			R_ZeroOne_seq_item = fifo_sequence_item::type_id::create($sformatf("ZeroOne_Read_seq_%0d",get_sequence_id()));
			R_ZeroOne_seq_item.w_data_range.constraint_mode(0);
			assert(R_ZeroOne_seq_item.randomize() with {rw == 0;rstn == 1;})
			else
			`uvm_error("Zero_OneRead_sequence","Randomization Failed");
			start_item(R_ZeroOne_seq_item);
			finish_item(R_ZeroOne_seq_item);
		end
	endtask
endclass : fifo_ZeroOneR_sequence