`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 02:02:39 PM
// Design Name: 
// Module Name: register
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
module register_file (
    input         clk,
    input         RegWrite,
    input  [4:0]  rs1,
    input  [4:0]  rs2,
    input  [4:0]  rd,
    input  [31:0] write_data,

    output reg [31:0] rd1,
    output reg [31:0] rd2
);

    reg [31:0] registers [0:31];
    integer i;

    // ================= INITIAL VALUES =================
    initial begin
        for(i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
        registers[1] = 5;
        registers[3] = 10;
        registers[4] = 15;
    end

    // ================= READ WITH BYPASS =================
    always @(*) begin
        // Default read from register file
        rd1 = (rs1 == 0) ? 32'b0 : registers[rs1];
        rd2 = (rs2 == 0) ? 32'b0 : registers[rs2];
        
        // Bypass: if writing to same register, use write_data instead
        if (RegWrite && rd != 0) begin
            if (rd == rs1)
                rd1 = write_data;
            if (rd == rs2)
                rd2 = write_data;
        end
    end

    // ================= WRITE =================
    always @(posedge clk) begin
        if (RegWrite && rd != 0)
            registers[rd] <= write_data;
    end

endmodule