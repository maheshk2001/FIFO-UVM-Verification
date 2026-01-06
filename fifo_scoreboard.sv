`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    fifo_sequence_item sco_item;
    uvm_analysis_imp#(fifo_sequence_item,fifo_scoreboard) sb_mon_port;

    int count_reset;
    int count_read;
    int count_write;
    int count_tests;
    int count_pass;
    int count_fail;

    logic [15:0] dummy_fifo [$];
    logic [15:0] expected_data;


    function new(string path = "fifo_scoreboard",uvm_component parent);
        super.new(path,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sb_mon_port = new("sb_mon_port",this);

        count_reset = 0;
        count_read = 0;
        count_write = 0;
        count_tests = 0;
        count_pass = 0;
        count_fail = 0;
        expected_data = 16'b0;
    endfunction

    function void write(fifo_sequence_item sco_item);
        count_tests++;
        if(!sco_item.rstn) begin
            count_reset++;
            if(sco_item.empty_flag) begin
                dummy_fifo.delete();
                count_pass++;
                `uvm_info("SCO",$sformatf("FIFO is Reset/Dumped_%0d",count_reset),UVM_NONE);
            end
            else begin
                dummy_fifo.delete();
                count_fail++;
                `uvm_info("SCO",$sformatf("FIFO is Reset/Dumped_%0d Flag_MISS %0b",count_reset,sco_item.empty_flag),UVM_NONE);
            end
            
        end

        else if(sco_item.rw) begin
            count_write++;
            if(dummy_fifo.size()==16) begin
                if(sco_item.full_flag) begin
                    count_pass++;
                    `uvm_info("SCO",$sformatf("FIFO_Full_Pass:%0h Element Discarded ",sco_item.w_data),UVM_NONE);
                end

                else begin
                    count_fail++;
                    `uvm_info("SCO",$sformatf("FIFO_Full_Fail:%0h Full_Flag:%0b",sco_item.w_data,sco_item.full_flag),UVM_NONE);
                end
            end

            else if (dummy_fifo.size() < 16 && !sco_item.full_flag) begin
                count_pass++;
                dummy_fifo.push_back(sco_item.w_data);
                `uvm_info("SCO",$sformatf("FIFO_Element_%0d :%0h ",dummy_fifo.size(),sco_item.w_data),UVM_NONE);
            end

            else begin
                count_fail++;
                `uvm_info("SCO",$sformatf("Write_Full_Flag_FAILED:%0b ",sco_item.full_flag),UVM_NONE);
            end
        end

        else if (!sco_item.rw) begin
            count_read++;
            if(dummy_fifo.size()>0) begin
                expected_data = dummy_fifo.pop_front();
                if(sco_item.r_data == expected_data) begin
                    count_pass++;
                    `uvm_info("SCO",$sformatf("FIFO_Read_Pass:%0h ",sco_item.r_data),UVM_NONE);
                end

                else begin
                    count_fail++;
                    `uvm_info("SCO",$sformatf("FIFO_Read_FAIL-Expected:%0h- DUT: %0h ",expected_data,sco_item.r_data),UVM_NONE);
                end 
            end

            else if(dummy_fifo.size()==0) begin
                if(sco_item.r_data == 16'b0 && sco_item.empty_flag) begin
                    count_pass++;
                    `uvm_info("SCO",$sformatf("FIFO_Read_Empty_Pass:%0h ",sco_item.r_data),UVM_NONE);
                end

                else begin
                    count_fail++;
                    `uvm_info("SCO",$sformatf("FIFO_Read_Empty_Fail:%0h,Empty Flag:%0b",sco_item.r_data,sco_item.empty_flag),UVM_NONE);
                end
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SCO",$sformatf("RESET_Count:%0d",count_reset),UVM_NONE);
        `uvm_info("SCO",$sformatf("READ_Count:%0d",count_read),UVM_NONE);
        `uvm_info("SCO",$sformatf("WRITE_Count:%0d",count_write),UVM_NONE);
        `uvm_info("SCO",$sformatf("PASS_Count:%0d",count_pass),UVM_NONE);
        `uvm_info("SCO",$sformatf("FAIL_Count:%0d",count_fail),UVM_NONE);
        `uvm_info("SCO",$sformatf("TEST_Count:%0d",count_tests),UVM_NONE);

    endfunction

endclass : fifo_scoreboard