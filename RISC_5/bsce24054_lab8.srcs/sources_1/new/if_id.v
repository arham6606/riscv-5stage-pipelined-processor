`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 01:14:10 PM
// Design Name: 
// Module Name: if_id
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

module IF_ID(
    input clk,
    input reset,
    input enable,
    input  [31:0] pc_in,
    input  [31:0] instr_in,

    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        pc_out    <= 0;
        instr_out <= 0;
    end

    else if(enable)
    begin
        pc_out    <= pc_in;
        instr_out <= instr_in;
    end

end

endmodule