`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 12:56:44
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input [31:0] adr,
    output reg [31:0] instr 
  );
  
   reg [31:0] rom [255:0];
  initial
  begin
   $readmemh("C:/Users/gopan/Control unit/pain.hex",rom);
  end
  always@(*) begin
  
  instr=rom[adr>>2];

  end
    
endmodule
