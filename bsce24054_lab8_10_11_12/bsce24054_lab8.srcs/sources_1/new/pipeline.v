`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 01:41:23 PM
// Design Name: 
// Module Name: pipeline
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

module pipeline_top(

    input clk,
    input reset

);

// ================= PC =================
wire [31:0] pc;
wire [31:0] pc_next;

// ================= INSTRUCTION FETCH =================
wire [31:0] instr;

// ================= IF/ID OUTPUTS =================
wire [31:0] ifid_pc;
wire [31:0] ifid_instr;

// ================= INSTRUCTION FIELDS =================
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

wire [6:0] opcode;

// ================= REGISTER FILE =================
wire [31:0] rd1;
wire [31:0] rd2;

// ================= IMMEDIATE =================
wire [31:0] imm_data;

// ================= CONTROL SIGNALS =================
wire RegWrite;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire Branch;
wire alu_src;

wire [1:0] alu_op;

// ================= ID/EX OUTPUTS =================
wire [31:0] idex_rd1;
wire [31:0] idex_rd2;
wire [31:0] idex_imm;

wire [4:0] idex_rd;

wire idex_RegWrite;
wire idex_MemRead;
wire idex_MemWrite;
wire idex_MemtoReg;
wire idex_ALUSrc;

wire [1:0] idex_alu_op;

wire [2:0] funct3;
wire [6:0] funct7;

wire [2:0] idex_funct3;
wire [6:0] idex_funct7;

// ================= EX STAGE =================
wire [31:0] alu_input;

wire [3:0] alu_control;

wire [31:0] alu_result;

wire zero;

// ================= EX/MEM OUTPUTS =================
wire [31:0] exmem_alu_result;
wire [31:0] exmem_write_data;

wire [4:0] exmem_rd;

wire exmem_RegWrite;
wire exmem_MemRead;
wire exmem_MemWrite;
wire exmem_MemtoReg;

// ================= MEM STAGE SIGNALS =================
wire [31:0] mem_read_data;

// ================= MEM/WB OUTPUTS =================
wire [31:0] memwb_mem_data;
wire [31:0] memwb_alu_result;
wire [4:0] memwb_rd;
wire memwb_RegWrite;
wire memwb_MemtoReg;

// ================= WRITEBACK MUX OUTPUT =================
wire [31:0] memwb_result;

// ================= FORWARDING SIGNALS =================
wire [1:0] forwardA;
wire [1:0] forwardB;
wire [31:0] alu_input_a;      // Forwarded input A
wire [31:0] alu_input_b;      // Forwarded input B

wire [4:0] idex_rs1;
wire [4:0] idex_rs2;

// ================= HAZARD DETECTION SIGNALS =================
wire stall;
wire flush;
wire [31:0] forwarded_rs2;


hazard_detection hazard_unit(
    .clk(clk),           // ? Add clk connection
    .reset(reset),       // ? Add reset connection
    .idex_rd(idex_rd),
    .idex_MemRead(idex_MemRead),
    .ifid_rs1(rs1),
    .ifid_rs2(rs2),
    .stall(stall),
    .flush(flush)
);
wire ifid_enable = !stall;
wire idex_enable = !stall;


// ================= PC MODULE =================
pc pc_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .pc_next(pc+4),
    .pc(pc)
);

// ================= IF/ID PIPELINE REGISTER =================
IF_ID ifid_inst(

    .clk(clk),
    .reset(reset || flush),
    .enable(ifid_enable),
    .pc_in(pc),
    .instr_in(instr),

    .pc_out(ifid_pc),
    .instr_out(ifid_instr)

);


// ================= INSTRUCTION MEMORY =================
instruction_memory im_inst(
    .addr(pc),
    .instr(instr)
);



// ================= INSTRUCTION FIELDS =================
assign rs1 = ifid_instr[19:15];
assign rs2 = ifid_instr[24:20];
assign rd  = ifid_instr[11:7];
assign opcode = ifid_instr[6:0];
assign funct3 = ifid_instr[14:12];
assign funct7 = ifid_instr[31:25];

// ================= CONTROL UNIT =================
control control_inst(

    .opcode(opcode),

    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(alu_op),
    .MemWrite(MemWrite),
    .ALUSrc(alu_src),
    .RegWrite(RegWrite)

);

// ================= REGISTER FILE =================
// NOTE: write_data is connected but will be updated when MEM/WB is added
register_file reg_inst(

    .clk(clk),
    .RegWrite(memwb_RegWrite),     // Updated: Now from MEM/WB
    .rs1(rs1),
    .rs2(rs2),
    .rd(memwb_rd),                  // Updated: Now from MEM/WB
    .write_data(memwb_result),     // Updated: Now from writeback mux

    .rd1(rd1),
    .rd2(rd2)

);

// ================= IMMEDIATE GENERATOR =================
imm_gen imm_inst(

    .instr(ifid_instr),
    .imm_ext(imm_data)

);

// ================= ID/EX PIPELINE REGISTER =================
ID_EX idex_inst(

    .clk(clk),
    .reset(reset),
    .enable(idex_enable),
    // DATA INPUTS
    .rd1_in(rd1),
    .rd2_in(rd2),
    .imm_in(imm_data),
    .rd_in(rd),
     .rs1_in(rs1),      // NEW - from instruction fields
    .rs2_in(rs2),      // NEW - from instruction fields
    
    // FUNCT FIELDS INPUT
    .funct3_in(funct3),
    .funct7_in(funct7),

    // CONTROL INPUTS
    .RegWrite_in(RegWrite),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .MemtoReg_in(MemtoReg),
    .ALUSrc_in(alu_src),
    .alu_op_in(alu_op),

    // DATA OUTPUTS
    .rd1_out(idex_rd1),
    .rd2_out(idex_rd2),
    .imm_out(idex_imm),
    .rd_out(idex_rd),
      .rs1_out(idex_rs1),    // NEW
    .rs2_out(idex_rs2),    // NEW
    // FUNCT FIELDS OUTPUT
    .funct3_out(idex_funct3),
    .funct7_out(idex_funct7),

    // CONTROL OUTPUTS
    .RegWrite_out(idex_RegWrite),
    .MemRead_out(idex_MemRead),
    .MemWrite_out(idex_MemWrite),
    .MemtoReg_out(idex_MemtoReg),
    .ALUSrc_out(idex_ALUSrc),
    .alu_op_out(idex_alu_op)

);



// ================= ALU CONTROL =================
ALU_Control alu_control_inst(

    .ALUOp(idex_alu_op),

    .funct3(idex_funct3),  
    .funct7(idex_funct7),  

    .ALUControl(alu_control)

);

// ================= ALU =================
alu alu_inst(

    .a(alu_input_a), 
    .b(alu_input_b),  

    .ALUControl(alu_control),

    .result(alu_result),

    .zero(zero)

);

// ================= EX/MEM PIPELINE REGISTER =================
wire [31:0] store_data = forwarded_rs2;

EX_MEM exmem_inst(

    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),
    .write_data_in(store_data),

    .rd_in(idex_rd),

    .RegWrite_in(idex_RegWrite),
    .MemRead_in(idex_MemRead),
    .MemWrite_in(idex_MemWrite),
    .MemtoReg_in(idex_MemtoReg),

    .alu_result_out(exmem_alu_result),
    .write_data_out(exmem_write_data),

    .rd_out(exmem_rd),

    .RegWrite_out(exmem_RegWrite),
    .MemRead_out(exmem_MemRead),
    .MemWrite_out(exmem_MemWrite),
    .MemtoReg_out(exmem_MemtoReg)

);

// ================= DATA MEMORY =================
data_memory data_mem_inst(

    .clk(clk),

    .MemRead(exmem_MemRead),
    .MemWrite(exmem_MemWrite),

    .addr(exmem_alu_result),
    .write_data(exmem_write_data),

    .read_data(mem_read_data)

);

// ================= MEM/WB PIPELINE REGISTER =================
MEM_WB memwb_inst(

    .clk(clk),
    .reset(reset),

    .mem_data_in(mem_read_data),
    .alu_result_in(exmem_alu_result),

    .rd_in(exmem_rd),

    .RegWrite_in(exmem_RegWrite),
    .MemtoReg_in(exmem_MemtoReg),

    .mem_data_out(memwb_mem_data),
    .alu_result_out(memwb_alu_result),

    .rd_out(memwb_rd),

    .RegWrite_out(memwb_RegWrite),
    .MemtoReg_out(memwb_MemtoReg)

);

// ================= WRITEBACK MUX =================
// Selects between memory data (for lw) and ALU result (for R-type/I-type)
assign memwb_result = memwb_MemtoReg ? memwb_mem_data : memwb_alu_result;


// ================= FORWARDING UNIT INSTANTIATION =================
forwarding_unit fwd_unit(
    .idex_rs1(idex_rs1),
    .idex_rs2(idex_rs2),
    .exmem_rd(exmem_rd),
    .exmem_RegWrite(exmem_RegWrite),
    .memwb_rd(memwb_rd),
    .memwb_RegWrite(memwb_RegWrite),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

// ================= FORWARDING MUX FOR INPUT A =================
forwarding_mux fwd_mux_a(
    .normal_input(idex_rd1),
    .exmem_result(exmem_alu_result),
    .memwb_result(memwb_result),
    .forward_sel(forwardA),
    .mux_out(alu_input_a)
);

// ================= FORWARDING MUX FOR INPUT B =================


forwarding_mux fwd_mux_b(
    .normal_input(idex_rd2),  // This will be the mux output from ALUSrc
    .exmem_result(exmem_alu_result),
    .memwb_result(memwb_result),
    .forward_sel(forwardB),
    .mux_out(forwarded_rs2)
);

// ================= ALU INPUT MUX =================


mux2_1_32bit alu_mux(

    .in0(forwarded_rs2),
    .in1(idex_imm),

    .sel(idex_ALUSrc),

    .out(alu_input_b)

);



endmodule