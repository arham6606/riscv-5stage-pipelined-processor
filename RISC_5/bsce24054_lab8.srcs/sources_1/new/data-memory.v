`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 02:26:30 PM
// Design Name: 
// Module Name: data-memory
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

module data_memory (
    input         clk,
    input         MemRead,
    input         MemWrite,
    input  [31:0] addr,
    input  [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] memory [0:63];

    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'b0;
      memory[0] = 0;
memory[1] = 0;

    end

    // Write
    always @(posedge clk) begin
        if (MemWrite)
            memory[addr[31:2]] <= write_data;
    end
    // Read
    assign read_data = (MemRead) ? memory[addr[31:2]] : 32'b0;
endmodule