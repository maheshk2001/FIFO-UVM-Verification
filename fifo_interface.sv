interface fifo_interface#(parameter width = 16, parameter depth = 16)(input w_clk, input r_clk);

	logic rstn;
	logic w_en;
	logic r_en;
	logic [width-1:0]w_data;
	logic [width-1:0]r_data;
	logic full_flag;
	logic empty_flag;
	
	clocking w_cb @(posedge w_clk);
		//output rstn;
		output w_en;
		output w_data;
		input full_flag;
	endclocking
	
	clocking r_cb @(posedge r_clk);
		//output rstn;
		output r_en;
		input r_data;
		input empty_flag;
	endclocking

endinterface : fifo_interface