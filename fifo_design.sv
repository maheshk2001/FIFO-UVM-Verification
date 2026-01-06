// Asynchronous FIFO Design
// 16-bit width, 16 locations deep
// Gray code synchronization for safe clock domain crossing

module Async_fifo #(
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4  // log2(16) = 4
)(
    // Write clock domain
    input  logic                    w_clk,
    input  logic                    rstn,
    input  logic                    w_en,
    input  logic [DATA_WIDTH-1:0]   w_data,
    output logic                    full_flag,
    
    // Read clock domain
    input  logic                    r_clk,
    input  logic                    r_en,
    output logic [DATA_WIDTH-1:0]   r_data,
    output logic                    empty_flag
);

    // Memory array
    logic [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    
    // Write and read pointers (binary)
    logic [ADDR_WIDTH:0] w_ptr, r_ptr;
    
    // Gray coded pointers
    logic [ADDR_WIDTH:0] w_ptr_gray, r_ptr_gray;
    
    // Synchronized Gray pointers
    logic [ADDR_WIDTH:0] w_ptr_gray_sync, r_ptr_gray_sync;
    
    // Synchronized registers for metastability prevention
    logic [ADDR_WIDTH:0] w_ptr_gray_sync1, w_ptr_gray_sync2;
    logic [ADDR_WIDTH:0] r_ptr_gray_sync1, r_ptr_gray_sync2;
    
    //==========================================================================
    // WRITE DOMAIN LOGIC
    //==========================================================================
    
    // Write pointer increment
    always_ff @(posedge w_clk or negedge rstn) begin
        if (!rstn)
            w_ptr <= '0;
        else if (w_en && !full_flag)
            w_ptr <= w_ptr + 1'b1;
    end
    
   // Write to memory
    always_ff @(posedge w_clk) begin
        if (w_en && !full_flag)
            fifo_mem[w_ptr[ADDR_WIDTH-1:0]] <= w_data;
    end
    
    // Binary to Gray conversion for write pointer
    always_ff @(posedge w_clk or negedge rstn) begin
        if (!rstn)
            w_ptr_gray <= '0;
        else
            w_ptr_gray <= (w_ptr >> 1) ^ w_ptr;  // Binary to Gray
    end
    
    // Synchronize read pointer to write clock domain (2-stage synchronizer)
    always_ff @(posedge w_clk or negedge rstn) begin
        if (!rstn) begin
            r_ptr_gray_sync1 <= '0;
            r_ptr_gray_sync2 <= '0;
        end else begin
            r_ptr_gray_sync1 <= r_ptr_gray;
            r_ptr_gray_sync2 <= r_ptr_gray_sync1;
        end
    end
    
    assign r_ptr_gray_sync = r_ptr_gray_sync2;
    
    // Full flag generation - COMBINATIONAL
    // FIFO is full when write pointer equals read pointer (with MSBs inverted)
    // In Gray code: w_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1] should be inverted of r_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1]
    assign full_flag = (w_ptr_gray == {~r_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                        r_ptr_gray_sync[ADDR_WIDTH-2:0]});
    
    //==========================================================================
    // READ DOMAIN LOGIC
    //==========================================================================
    
    // Combinatorial data read from current pointer
    logic [DATA_WIDTH-1:0] r_data_comb;
    assign r_data_comb = fifo_mem[r_ptr[ADDR_WIDTH-1:0]];
    
    // Register the read output to capture data before pointer increments
    // Only update when read is requested, hold otherwise
    always_ff @(posedge r_clk or negedge rstn) begin
        if (!rstn)
            r_data <= '0;
        else if (r_en && !empty_flag)
            r_data <= r_data_comb;
    end
    
    // Read pointer increment
    always_ff @(posedge r_clk or negedge rstn) begin
        if (!rstn)
            r_ptr <= '0;
        else if (r_en && !empty_flag)
            r_ptr <= r_ptr + 1'b1;
    end
    
    // Binary to Gray conversion for read pointer
    always_ff @(posedge r_clk or negedge rstn) begin
        if (!rstn)
            r_ptr_gray <= '0;
        else
            r_ptr_gray <= (r_ptr >> 1) ^ r_ptr;  // Binary to Gray
    end
    
    // Synchronize write pointer to read clock domain (2-stage synchronizer)
    always_ff @(posedge r_clk or negedge rstn) begin
        if (!rstn) begin
            w_ptr_gray_sync1 <= '0;
            w_ptr_gray_sync2 <= '0;
        end else begin
            w_ptr_gray_sync1 <= w_ptr_gray;
            w_ptr_gray_sync2 <= w_ptr_gray_sync1;
        end
    end
    
    assign w_ptr_gray_sync = w_ptr_gray_sync2;
    
    // Empty flag generation - COMBINATIONAL
    // FIFO is empty when read pointer equals write pointer
    assign empty_flag = (r_ptr_gray == w_ptr_gray_sync);

endmodule : Async_fifo
