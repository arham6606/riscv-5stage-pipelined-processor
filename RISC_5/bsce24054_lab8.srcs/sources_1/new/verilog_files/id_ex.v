`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 01:18:38 PM
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: x
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ID_EX(
    input clk,
    input reset,
    input enable,
    // DATA INPUTS
    input [31:0] rd1_in,
    input [31:0] rd2_in,
    input [31:0] imm_in,
    input [4:0] rd_in,
    input [4:0] rs1_in,    // NEW
    input [4:0] rs2_in,    // NEW
    
    // FUNCT FIELDS
    input [2:0] funct3_in,
    input [6:0] funct7_in,
    
    // CONTROL INPUTS
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,
    input ALUSrc_in,
    input [1:0] alu_op_in,
    
    // DATA OUTPUTS
    output reg [31:0] rd1_out,
    output reg [31:0] rd2_out,
    output reg [31:0] imm_out,
    output reg [4:0] rd_out,
    output reg [4:0] rs1_out,   // NEW
    output reg [4:0] rs2_out,   // NEW
    
    // FUNCT OUTPUTS
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,
    
    // CONTROL OUTPUTS
    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,
    output reg ALUSrc_out,
    output reg [1:0] alu_op_out
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        rd1_out <= 0;
        rd2_out <= 0;
        imm_out <= 0;
        rd_out <= 0;
        rs1_out <= 0;    // NEW
        rs2_out <= 0;    // NEW
        funct3_out <= 0;
        funct7_out <= 0;
        RegWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        MemtoReg_out <= 0;
        ALUSrc_out <= 0;
        alu_op_out <= 0;
    end
    else if(enable) begin
        rd1_out <= rd1_in;
        rd2_out <= rd2_in;
        imm_out <= imm_in;
        rd_out <= rd_in;
        rs1_out <= rs1_in;    // NEW
        rs2_out <= rs2_in;    // NEW
        funct3_out <= funct3_in;
        funct7_out <= funct7_in;
        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemtoReg_out <= MemtoReg_in;
        ALUSrc_out <= ALUSrc_in;
        alu_op_out <= alu_op_in;
    end
end

endmodule