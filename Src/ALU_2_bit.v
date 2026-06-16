`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 22:30:39
// Design Name: 
// Module Name: ALU_2_bit
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


module ALU_n_bit
#(parameter n=31)
(input  [n:0] A,
 input  [n:0] B,
 input  [3:0] OP,
 output reg   z,
 output reg   c,
 output reg   negative,
 output reg   [n:0] out
);

always@(*) begin
    c        = 1'b0;
    negative = 1'b0;

    case(OP)
        4'b0000: {c, out} = A + B;                          // ADD

        4'b0001: begin                                       // SUB
                 out = A - B;
                 c   = (A < B);
                 end

        4'b0010: out = A & B;                               // AND

        4'b0011: out = A | B;                               // OR

        4'b0100: out = A ^ B;                               // XOR

        4'b0101: out = A << B[4:0];                         // SLL  logical shift left

        4'b0110: out = A >> B[4:0];                         // SRL  logical shift right

        4'b0111: out = $signed(A) >>> B[4:0];               // SRA  arithmetic shift right

        4'b1000: out = ($signed(A) < $signed(B)) ? 1 : 0;  // SLT  signed less than

        4'b1001: out = (A < B) ? 1 : 0;                    // SLTU unsigned less than

        default: out = 0;
    endcase

    z        = (out == 0) ? 1'b1 : 1'b0;
    negative = out[n];
end

endmodule
