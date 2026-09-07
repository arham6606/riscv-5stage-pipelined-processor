`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 12:47:18 PM
// Design Name: 
// Module Name: single_cycle
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
module single_cycle(
input clk,
input reset
);

// ================= CONTROL SIGNALS =================
wire RegWrite, MemRead, MemWrite, MemtoReg, Branch;
wire [1:0] alu_op;
wire alu_src;

wire zero;
wire result;

// ================= WIRES =================
wire [31:0] pc, pc_next;
wire [31:0] inst;

wire [4:0] r1, r2, rd;
wire [6:0] op_code;

wire [31:0] write_data;
wire [31:0] rd1, rd2;

wire [31:0] pc_plus4;

wire [31:0] imm_gen_to_add;
wire [31:0] imm_gen_shift;

wire [31:0] st_mux;

wire [31:0] alu_input;
wire [31:0] alu_output;

wire [31:0] mem_data;

// ALU CONTROL WIRES
wire [2:0] funct3;
wire [6:0]funct7;

wire [3:0] alu_control;

// ================= MODULES =================

// ================= PC =================
pc pc_inst(
    clk,
    reset,
    pc_next,
    pc
);

// ================= Instruction Memory =================
instruction_memory inst_inst(
    pc,
    inst
);

// ================= Instruction Fields =================
assign r1       = inst[19:15];
assign r2       = inst[24:20];
assign rd       = inst[11:7];
assign op_code  = inst[6:0];

assign funct3   = inst[14:12];
assign funct7 = inst[31:25];

// ================= Control Unit =================
control cont_inst(
    op_code,
    Branch,
    MemRead,
    MemtoReg,
    alu_op,
    MemWrite,
    alu_src,
    RegWrite
);

// ================= Register File =================
register_file reg_inst(
    clk,
    RegWrite,
    r1,
    r2,
    rd,
    write_data,
    rd1,
    rd2
);

// ================= PC + 4 =================
adder_32bit addr_inst(
    pc,
    32'd4,
    pc_plus4
);

// ================= Immediate Generator =================
imm_gen imm_gen_inst(
    inst,
    imm_gen_to_add
);

// ================= Shift Left =================
//shift_left1 shift_inst(
  //  imm_gen_to_add,
   // imm_gen_shift
//);

// ================= Branch Address =================
adder_32bit addr_2inst(
    pc,
    imm_gen_shift,
    st_mux
);

// ================= Branch Decision =================
assign result = Branch & zero;

// ================= PC MUX =================
mux2_1_32bit mux1_inst(
    pc_plus4,
    st_mux,
    result,
    pc_next
);

// ================= ALU Input MUX =================
mux2_1_32bit mux2_inst(
    rd2,
    imm_gen_to_add,
    alu_src,
    alu_input
);

// ================= ALU Control =================
ALU_Control alu_cont_inst(
    alu_op,
    funct3,
    funct7,
    alu_control
);

// ================= ALU =================
alu alu_inst(
    rd1,
    alu_input,
    alu_control,
    alu_output,
    zero
);

// ================= Data Memory =================
data_memory dmem_inst(
    clk,
    MemRead,
    MemWrite,
    alu_output,
    rd2,
    mem_data
);

// ================= Write Back MUX =================
mux2_1_32bit mux3_inst(
    alu_output,
    mem_data,
    MemtoReg,
    write_data
);

endmodule