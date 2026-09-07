`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2026 01:01:39 PM
// Design Name: 
// Module Name: control
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


module control(
        input [6:0] opcode,
        output reg Branch,
        output reg MemRead,
        output reg MemtoReg,
        output reg [1:0] ALUOp,
        output reg MemWrite,
        output reg ALUSrc,
        output reg RegWrite
    );
    
    always @(*) 
begin
    // Default values
    Branch   = 0;
    MemRead  = 0;
    MemtoReg = 0;
    ALUOp    = 2'b00;
    MemWrite = 0;
    ALUSrc   = 0;
    RegWrite = 0;

    case(opcode)
     // R-Type
        7'b0110011:
        begin
            ALUSrc   = 0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 0;
            ALUOp    = 2'b10;
        end
        // I-Type (Load)
        7'b0000011:
        begin
            ALUSrc   = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead  = 1;
            MemWrite = 0;
            Branch   = 0;
            ALUOp    = 2'b00;
        end
         // S-Type (Store)
        7'b0100011:
        begin
            ALUSrc   = 1;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead  = 0;
            MemWrite = 1;
            Branch   = 0;
            ALUOp    = 2'b00;
        end
        
          // SB-Type (Branch)
        7'b1100011:
        begin
            ALUSrc   = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 1;
            ALUOp    = 2'b01;
        end

    endcase
end

endmodule