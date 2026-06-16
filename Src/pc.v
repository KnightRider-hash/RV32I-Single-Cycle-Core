`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 19:10:38
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input pcsrc,
    input rst,
    input [31:0] imm,
    output reg [31:0] adr
);
initial
adr=32'b0;
always@(posedge clk)begin
 if(rst==1'b1)
  adr<=32'b0;
 else if(pcsrc==1'b1)
  adr<=adr + imm;
 else
  adr<=adr + 3'b100;
 end 
 endmodule  

