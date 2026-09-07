`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:51:08 PM
// Design Name: 
// Module Name: instruction-memory
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
module instruction_memory (
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] memory [0:63];
    integer i;
    // ================= INITIALIZE INSTRUCTIONS =================
    initial begin
    for(i = 0; i < 64; i = i + 1)
        memory[i] = 32'h00000013;  // NOP
// add x2,x3,x4
memory[0] = 32'b0000000_00100_00011_000_00010_0110011;

// sub x5,x2,x1
memory[1] = 32'b0100000_00001_00010_000_00101_0110011;

// and x6,x5,x2
memory[2] = 32'b0000000_00010_00101_111_00110_0110011;

// or x7,x6,x1
memory[3] = 32'b0000000_00001_00110_110_00111_0110011;

// sw x7,0(x1)
memory[4] = 32'b0000000_00111_00001_010_00000_0100011;

// lw x8,0(x1)
memory[5] = 32'b0000000_00000_00001_010_01000_0000011;

// add x9,x8,x1
memory[6] = 32'b0000000_00001_01000_000_01001_0110011;

// sub x10,x9,x3
memory[7] = 32'b0100000_00011_01001_000_01010_0110011;

end
    // ================= FETCH =================
    assign instr = memory[addr[31:2]];

endmodule