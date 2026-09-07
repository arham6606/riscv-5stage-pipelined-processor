`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 11:39:48 AM
// Design Name: 
// Module Name: forwarding_unit
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

module forwarding_unit(
    // EX Stage inputs (from ID/EX register)
    input [4:0] idex_rs1,
    input [4:0] idex_rs2,
    
    // EX/MEM stage outputs
    input [4:0] exmem_rd,
    input exmem_RegWrite,
    
    // MEM/WB stage outputs
    input [4:0] memwb_rd,
    input memwb_RegWrite,
    
    // Forwarding control outputs
    output reg [1:0] forwardA,  // 00=no forward, 01=from EX/MEM, 10=from MEM/WB
    output reg [1:0] forwardB   // 00=no forward, 01=from EX/MEM, 10=from MEM/WB
);

always @(*) begin
    // Default: no forwarding
    forwardA = 2'b00;
    forwardB = 2'b00;
    
    // Forwarding for ALU input A (rs1)
    // Check if EX/MEM has a result for rs1
    if (exmem_RegWrite && exmem_rd != 0 && exmem_rd == idex_rs1)
        forwardA = 2'b01;  // Forward from EX/MEM
    
    // Check if MEM/WB has a result for rs1 (only if EX/MEM doesn't have it)
    else if (memwb_RegWrite && memwb_rd != 0 && memwb_rd == idex_rs1)
        forwardA = 2'b10;  // Forward from MEM/WB
    
    // Forwarding for ALU input B (rs2)
    // Check if EX/MEM has a result for rs2
    if (exmem_RegWrite && exmem_rd != 0 && exmem_rd == idex_rs2)
        forwardB = 2'b01;  // Forward from EX/MEM
    
    // Check if MEM/WB has a result for rs2 (only if EX/MEM doesn't have it)
    else if (memwb_RegWrite && memwb_rd != 0 && memwb_rd == idex_rs2)
        forwardB = 2'b10;  // Forward from MEM/WB
end

endmodule