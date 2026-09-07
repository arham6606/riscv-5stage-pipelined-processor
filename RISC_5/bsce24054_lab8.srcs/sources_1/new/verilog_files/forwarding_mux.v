`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 11:40:56 AM
// Design Name: 
// Module Name: forwarding_mux
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

module forwarding_mux(
    input [31:0] normal_input,   // From ID/EX (register value)
    input [31:0] exmem_result,   // From EX/MEM stage
    input [31:0] memwb_result,   // From MEM/WB stage
    input [1:0] forward_sel,     // Select from forwarding unit
    
    output reg [31:0] mux_out
);

always @(*) begin
    case (forward_sel)
        2'b00: mux_out = normal_input;      // No forwarding
        2'b01: mux_out = exmem_result;      // Forward from EX/MEM
        2'b10: mux_out = memwb_result;      // Forward from MEM/WB
        default: mux_out = normal_input;
    endcase
end

endmodule