`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2026 17:19:02
// Design Name: 
// Module Name: registers
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


module registers(
input [4:0] src1, // location for data A
input [4:0] src2, // location for data B 
input [4:0] dest, // location for result
output [31:0] data1, //data taking path 
output [31:0] data2, // data taking path
input [31:0] rs, // data giving path
input rd,
input clk
);
reg [31:0] x [31:0];
initial begin
x[0]=0;
end
assign data1=(src1==5'b00000) ?32'b0 : x[src1];
assign data2=(src2==5'b00000) ?32'b0 : x[src2];


always@(posedge clk)begin
if(rd==1'b1 && dest!=5'b0)
 x[dest]<=rs;
 end
endmodule
