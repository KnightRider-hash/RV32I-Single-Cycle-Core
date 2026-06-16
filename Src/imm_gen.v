`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 18:42:26
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [1:0] immsrc,
    input [31:0] instr,
    output reg [31:0] result
    );
    always@(*)begin
case(immsrc)
2'b00 : result={{20{instr[31]}},instr[31:20]};
2'b01 : result={{20{instr[31]}},instr[31:25],instr[11:7]};
2'b10 : result={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
2'b11 : begin 
     if(instr[6:0]==7'b0110111)
       result={instr[31:12],{12{1'b0}}};
     else
    result={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
    end
default : result=32'b0;
endcase
end
endmodule
