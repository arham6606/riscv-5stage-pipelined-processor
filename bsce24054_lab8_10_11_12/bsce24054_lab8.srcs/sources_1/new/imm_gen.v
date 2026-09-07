`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 03:10:12 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen (
    input  [31:0] instr,
    output reg [31:0] imm_ext
);

always @(*) begin
    case (instr[6:0])  // opcode

        // I-type (addi, lw)
        7'b0010011, 7'b0000011: 
            imm_ext = {{20{instr[31]}}, instr[31:20]};

        // S-type (sw)
        7'b0100011:
            imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        // B-type (branch)
        7'b1100011:
            imm_ext = {{19{instr[31]}}, instr[31], instr[7],
                        instr[30:25], instr[11:8], 1'b0};
        default:
            imm_ext = 32'b0;
    endcase
end
endmodule