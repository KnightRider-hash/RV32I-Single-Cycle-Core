`timescale 1ns / 1ps

module pc(
    input clk,
    input pcsrc,
    input jalr_sel,          // NEW: Signal from Control Unit
    input rst,
    input [31:0] imm,
    input [31:0] alu_result, // NEW: Calculated target address from ALU
    output reg [31:0] adr
);

    initial adr = 32'b0;

    always @(posedge clk) begin
        if (rst == 1'b1)
            adr <= 32'b0;
        else if (jalr_sel == 1'b1)
            adr <= alu_result;  // JALR requires the ALU's exact calculation (rs1 + imm)
        else if (pcsrc == 1'b1)
            adr <= adr + imm;   // Branches and JAL use relative offset (PC + imm)
        else
            adr <= adr + 32'd4; // Normal execution
    end 
endmodule
