`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:03:44 PM
// Design Name: 
// Module Name: tb
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
module imm_shift_tb;

    reg [31:0] instr;
    wire [31:0] imm_ext;
    wire [31:0] shifted;

    imm_gen uut1 (
        .instr(instr),
        .imm_ext(imm_ext)
    );

    shift_left1 uut2 (
        .in(imm_ext),
        .out(shifted)
    );

    initial begin
        $display("==== Testing ImmGen + Shift ====");

        // Example I-type (addi)
        instr = 32'h00100093; // imm = 1
        #10;
        $display("Imm = %d, Shifted = %d", imm_ext, shifted);

        $finish;
    end

endmodule