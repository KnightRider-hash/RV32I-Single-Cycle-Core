module UART(
    input [7:0] data_in,
    input clk,
    input start,
    output reg busy,
    output reg daout
);


reg Tick;
reg [9:0] mem;
reg [3:0] bit_cnt;
reg [25:0] acc;

parameter CLK_FREQ = 50_000_000; // clock speed (The Bucket)
parameter BAUD_RATE = 115_200;   // desired speed (The Pour)

initial begin 
 Tick=1'b0;
 daout=1'b1;
 busy=1'b0;
 acc=26'b0;
end


always@(posedge clk)begin 

if (acc >= (CLK_FREQ - BAUD_RATE)) begin 
    
    // The exact equation you just wrote!
    acc <= acc - CLK_FREQ + BAUD_RATE; 
    Tick <= 1'b1;
    
end else begin
    
    // Normal cycle, just keep pouring
    acc <= acc + BAUD_RATE;
    Tick <= 1'b0;
    
end

if(busy==1'b0 & start==1'b1) begin // packaging take place
  mem<={1'b1,data_in,1'b0};
  busy<=1'b1;
  bit_cnt<=1'b0;
end 

if(busy == 1'b1 && Tick == 1'b1) begin
            
 daout <= mem[0];          
  mem <= {1'b1, mem[9:1]};   // shift register  
  bit_cnt <= bit_cnt + 1;    
 
if(bit_cnt == 9)
  busy <= 1'b0;            
 end
end
endmodule
