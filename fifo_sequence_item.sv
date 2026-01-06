`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_sequence_item extends uvm_sequence_item;
	
	function new (string path = "fifo_sequence_item");
		super.new(path);
	endfunction
	
	// Inputs
	rand logic rstn;
	rand logic [15:0] w_data;
	// Read or Write pick
	rand bit rw;
	
	//Outputs
	logic [15:0]r_data;
	logic full_flag;
	logic empty_flag;
	
	// Factory Registering
	`uvm_object_utils_begin(fifo_sequence_item);
	//Inputs
	`uvm_field_int (rstn , UVM_DEFAULT);
	`uvm_field_int (w_data , UVM_DEFAULT);
	`uvm_field_int (rw , UVM_DEFAULT);
	//Outputs
	`uvm_field_int (r_data , UVM_DEFAULT);
	`uvm_field_int (full_flag , UVM_DEFAULT);
	`uvm_field_int (empty_flag , UVM_DEFAULT);
	`uvm_object_utils_end
	
	// RESET signal constraints
	constraint rst_dist {rstn dist {1:=999,0:=1};}

	//RESET and rw interaction constraint
	constraint rst_rw_int {if (!rstn) rw == 0;}
	
	//rw distribution constraint
	constraint rw_dist {rw dist {0:=30,1:=70};}
	
	//w_data range constraint
	constraint w_data_range { w_data inside {[10:210]};}
	
	// Directed Reset sequence item
	function void make_fifo_reset_item ();
		rstn = 0;
		w_data = 0;
		rw = 0;
	endfunction :make_fifo_reset_item

	function void print_item(string comp);
    if (rw == 1)  begin // Write operation
        `uvm_info(comp, $sformatf("WRITE: rstn=%0b, w_data=0x%0h, full_flag=%0b", 
                                  rstn, w_data, full_flag), UVM_NONE);
    end
    else begin    // Read operation
        `uvm_info(comp, $sformatf("READ: rstn=%0b, r_data=0x%0h, empty_flag=%0b", 
                                  rstn, r_data, empty_flag), UVM_NONE);
    end
	endfunction
	
endclass : fifo_sequence_item