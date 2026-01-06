`include "uvm_macros.svh"
`include "fifo_interface.sv"
`include "fifo_pkg.sv"

import uvm_pkg::*;
import fifo_pkg::*;

module tb_top;

bit w_clk;
bit r_clk;

initial begin
    w_clk = 0;
    r_clk = 0;
end

always #5 w_clk = ~w_clk;
always #7 r_clk = ~r_clk;

fifo_interface abc_if(w_clk,r_clk);

Async_fifo dut (
    .w_clk(abc_if.w_clk),
    .r_clk(abc_if.r_clk),
    .rstn(abc_if.rstn),
    .w_en(abc_if.w_en),
    .r_en(abc_if.r_en),
    .w_data(abc_if.w_data),
    .r_data(abc_if.r_data),
    .full_flag(abc_if.full_flag),
    .empty_flag(abc_if.empty_flag)
);

initial begin
    uvm_config_db#(virtual fifo_interface)::set(null,"*","interface",abc_if);
    run_test("fifo_test");
end


endmodule


// Interface
// logic rstn;
// 	logic w_en;
// 	logic r_en;
// 	logic [width-1:0]w_data;
// 	logic [width-1:0]r_data;
// 	logic full_flag;
// 	logic empty_flag;
// DUT	
// (
//     // Write clock domain
//     input  logic                    w_clk,
//     input  logic                    rstn,
//     input  logic                    w_en,
//     input  logic [DATA_WIDTH-1:0]   w_data,
//     output logic                    full_flag,
    
//     // Read clock domain
//     input  logic                    r_clk,
//     input  logic                    r_en,
//     output logic [DATA_WIDTH-1:0]   r_data,
//     output logic                    empty_flag
// );