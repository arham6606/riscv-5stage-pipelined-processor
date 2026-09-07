`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 01:38:09 PM
// Design Name: 
// Module Name: single_cycle_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module single_cycle_tb;

    // ================= INPUTS =================
    reg clk;
    reg reset;

    // ================= DUT =================
    single_cycle uut(
        .clk(clk),
        .reset(reset)
    );

    // ================= CLOCK =================
    always #5 clk = ~clk;

    // ================= INTERNAL SIGNALS =================
    wire [31:0] PC_Out;
    wire [31:0] Instruction;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    wire [31:0] Imm_Ext;

    wire [31:0] ALU_Input;
    wire [31:0] ALU_Result;

    wire [31:0] Memory_Data;

    wire [31:0] Write_Back;

    wire Zero;

    // ================= CONTROL SIGNALS =================
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;
    wire ALUSrc;

    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    // ================= ASSIGN INTERNAL SIGNALS =================
    assign PC_Out      = uut.pc;
    assign Instruction = uut.inst;

    assign ReadData1   = uut.rd1;
    assign ReadData2   = uut.rd2;

    assign Imm_Ext     = uut.imm_gen_to_add;

    assign ALU_Input   = uut.alu_input;
    assign ALU_Result  = uut.alu_output;

    assign Memory_Data = uut.mem_data;

    assign Write_Back  = uut.write_data;

    assign Zero        = uut.zero;

    // CONTROL SIGNALS
    assign RegWrite    = uut.RegWrite;
    assign MemRead     = uut.MemRead;
    assign MemWrite    = uut.MemWrite;
    assign MemtoReg    = uut.MemtoReg;
    assign Branch      = uut.Branch;
    assign ALUSrc      = uut.alu_src;

    assign ALUOp       = uut.alu_op;
    assign ALUControl  = uut.alu_control;

    // ================= INITIAL BLOCK =================
    initial
    begin

        clk = 0;
        reset = 1;

        // Apply reset
        #10;
        reset = 0;

        // Run simulation
        #200;

        $finish;

    end

    // ================= MONITOR =================
    initial
    begin

        $monitor(
        "TIME=%0t | PC=%h | INSTR=%h | RD1=%d | RD2=%d | IMM=%d | ALU_IN=%d | ALU_OUT=%d | MEM_DATA=%d | WB=%d | ZERO=%b",
        $time,
        PC_Out,
        Instruction,
        ReadData1,
        ReadData2,
        Imm_Ext,
        ALU_Input,
        ALU_Result,
        Memory_Data,
        Write_Back,
        Zero
        );

    end

endmodule