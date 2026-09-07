`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:27:34 PM
// Design Name: 
// Module Name: PC
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

module pc (
    input         clk,
    input         reset,
    input stall,
    input  [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'b0;       // start from address 0
    else if(!stall)
        pc <= pc_next;     // update to next instruction
end

endmodule