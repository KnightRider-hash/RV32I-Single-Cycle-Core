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
input [3:0] mask,
input clk,
input [31:0] adr,
output reg [31:0] daout);

reg [31:0] store [0:31];

always@(*)
 begin
if(memrd==1) 
   daout=store[adr>>2]; // no need for waiting as blocking assignment used
else
   daout=32'b0;
end

always @(posedge clk) begin 
 if(mask[0]==1) 
 store[adr>>2][7:0]<=dain[7:0]; // for safely keep the data using same width on both side or data corruption

 if(mask[1]==1) 
 store[adr>>2][15:8]<=dain[15:8];

  if(mask[2]==1) 
 store[adr>>2][23:16]<=dain[23:16];

  if(mask[3]==1) 
 store[adr>>2][31:24]<=dain[31:24];
  
end 
endmodule
