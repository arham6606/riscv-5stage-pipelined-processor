`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 12:57:46 PM
// Design Name: 
// Module Name: hazard_detection
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
module hazard_detection(
    input clk,
    input reset,
    input [4:0] idex_rd,
    input idex_MemRead,
    input [4:0] ifid_rs1,
    input [4:0] ifid_rs2,
    output reg stall,
    output reg flush
);

reg stall_next;

// Combinational logic: determine next stall value
always @(*) begin
    // Default: no stall
    stall_next = 0;
    flush = 0;
    
    // ONLY stall for LOAD instructions that are followed by instruction using loaded reg
    if (idex_MemRead &&                                    // LW in EX stage
        (idex_rd == ifid_rs1 || idex_rd == ifid_rs2) &&   // Next instruction uses it
        idex_rd != 0) begin                                // Not x0
        stall_next = 1;    // ? Assign to stall_next, not stall!
        flush = 0;
    end
end

// Sequential logic: register stall (1 cycle only)
always @(posedge clk or posedge reset) begin
    if(reset) begin
        stall <= 0;
        flush <= 0;        // Also reset flush
    end
    else begin
        stall <= stall_next;   // ? Only 1 cycle!
        flush <= 0;            // Flush is combinational, but safe to reset
    end
end

endmodule