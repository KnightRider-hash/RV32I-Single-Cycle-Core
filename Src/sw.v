module sw(

input [31:0] dat_in,

input [2:0] funct3,

input [1:0] aluo,

output reg [31:0] out,

output reg [3:0] mask



);



always@(*) begin



 out=32'b0;  //safety

 mask=4'b0000; // related mask

  case(funct3)

   3'b000: begin 

    out={{4{dat_in[7:0]}}}; //takes lower 8 bit and makes 4 copy to fit 32 bit

     case(aluo)

      2'b00: mask = 4'b0001; // 7-0 bit

      2'b01: mask = 4'b0010; //15-8 bit

      2'b10: mask = 4'b0100; //23-16 bit

      2'b11: mask = 4'b1000; //31-24 bit

     endcase

     end 

  3'b001: begin

    out={{2{dat_in[15:0]}}}; // takes lower 16 bit and makes 2 copy 



    if (aluo[1]==1'b0) // bit 15-0 

      mask=4'b0011;

    else

      mask=4'b1100; // bit 31-16

   end 



  3'b010: begin

     out=dat_in; // full bit

     mask=4'b1111;

   end

  default: begin

    mask=4'b0000;

  end

endcase

end 

endmodule     