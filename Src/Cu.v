`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2026 12:14:24
// Design Name: 
// Module Name: Cu
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


module Cu(
 input [6:0] opcode,
 input [2:0] funct3,
 input funct7,
 output reg Rgwrite,
 output reg branch,
 output reg alusrc,
 output reg memread,
 output reg memwrite,
 output reg jump,
 output reg [1:0] memtreg,
 output reg [1:0] aluop,
 output reg [1:0] immsrc,
 output reg [3:0] op
 );
 always@(*)begin
 
 Rgwrite  = 1'b0;
 branch   = 1'b0;
 alusrc   = 1'b0;
 memread  = 1'b0;
 memwrite = 1'b0;
 jump     = 1'b0;
 memtreg  = 2'b00;
 aluop    = 2'b00;
 immsrc   = 2'b00;
 
case(opcode)
7'b0110011: begin   //R-type
           Rgwrite=1'b1;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b0;
           aluop=2'b10;
           alusrc=1'b0;
           memtreg=2'b00;
          //immsrc=2'b00;
           end
7'b0010011: begin  //I-type
           Rgwrite=1'b1;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b0;
           aluop=2'b10;
           alusrc=1'b1;
           memtreg=2'b00;
           immsrc=2'b00;
           end         
7'b0000011: begin   // i-type-load
           Rgwrite=1'b1;
           memread=1'b1;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b0;
           aluop=2'b00;
           alusrc=1'b1;
           memtreg=2'b01;
           immsrc=2'b00;
           end 
7'b0100011: begin   // S-type 
           Rgwrite=1'b0;
           memread=1'b0;
           memwrite=1'b1;
           branch=1'b0;
           jump=1'b0;
           aluop=2'b00;
           alusrc=1'b1;
           memtreg=2'b00;
           immsrc=2'b01;
           end                  
7'b1100011: begin  // B-type 
           Rgwrite=1'b0;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b1;
           jump=1'b0;
           aluop=2'b01;
           alusrc=1'b0;
           memtreg=2'b00;
           immsrc=2'b10;
           end  
7'b0110111: begin   // U-type 
           Rgwrite=1'b1;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b0;
           aluop=2'b00;
           alusrc=1'b1;
           memtreg=2'b00;
           immsrc=2'b11;
           end                 
7'b1101111: begin  // jal 
           Rgwrite=1'b1;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b1;
           memtreg=2'b10;
           immsrc=2'b11;
           end
7'b1100111: begin  // jalr 
           Rgwrite=1'b1;
           memread=1'b0;
           memwrite=1'b0;
           branch=1'b0;
           jump=1'b1;
           aluop=2'b00;
           alusrc=1'b1;
           memtreg=2'b10;
           immsrc=2'b11;
           end
default:  begin
           Rgwrite=1'b0;
           memread=1'b0;
           memwrite=1'b0;
           end
endcase 

case(aluop)
2'b00: op=4'b0000;

2'b01: op=4'b0001;

2'b10: case(funct3)
   3'b000: begin
         if(funct7 == 0)
          op=4'b0000;
         else 
           op=4'b0001;
         end
    3'b111: op=4'b0010;
    3'b110: op=4'b0011;
    3'b100: op=4'b0100;  
    3'b010: op=4'b1000;
    3'b011: op=4'b1001;
    3'b001: op=4'b0101;
    3'b101: op=(funct7 == 1)? 4'b0111:4'b0110; 
    default: op= 4'b0000; 
    endcase
default: op = 4'b0000;    
endcase                                     
end       
endmodule
