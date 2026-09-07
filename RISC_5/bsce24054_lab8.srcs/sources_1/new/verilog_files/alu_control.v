`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2026 01:17:15 PM
// Design Name: 
// Module Name: alu_control
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

module ALU_Control(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg [3:0] ALUControl
);

always @(*) 
begin

    case(ALUOp)

        // Load / Store -> ADD
        2'b00:
            ALUControl = 4'b0010;

        // Branch -> SUB
        2'b01:
            ALUControl = 4'b0110;

        // R-Type Instructions
        2'b10:
        begin
            case({funct7, funct3})

                // ADD
                {7'b0000000, 3'b000}:
                    ALUControl = 4'b0010;

                // SUB
                {7'b0100000, 3'b000}:
                    ALUControl = 4'b0110;

                // AND
                {7'b0000000, 3'b111}:
                    ALUControl = 4'b0000;

                // OR
                {7'b0000000, 3'b110}:
                    ALUControl = 4'b0001;

                // Default
                default:
                    ALUControl = 4'bxxxx;

            endcase
        end

        default:
            ALUControl = 4'bxxxx;

    endcase

end

endmodule