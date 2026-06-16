`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 20:08:06
// Design Name: 
// Module Name: ram
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


module ram(
input [31:0] dain,
input memrd,
input memwr,
input clk,
input [31:0] adr,
output reg [31:0] daout);

reg [31:0] store [0:31];

always@(*)
 begin
if(memrd==1) 
   daout<=store[adr>>2];
else
   daout<=32'b0;
end

always @(posedge clk) begin 
 if(memwr==1)
  store[adr>>2]<=dain;
 end 
endmodule
