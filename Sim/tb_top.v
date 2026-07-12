`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 22:41:01
// Design Name: 
// Module Name: tb_top2
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

`timescale 1ns / 1ps

module tb_top2;
    reg clk;
    reg rst;

    // Instantiate your processor (no UART pin needed for this simulation)
    top2 uut (
        .clk(clk),
        .rst(rst)
        //.uart_tx_pin() 
    );

    // Generate Clock
    always #5 clk = ~clk;

    initial begin
        // 1. Reset the CPU
        clk = 0; 
        rst = 1;
        #20 rst = 0;

        // 2. Let the CPU run for enough cycles to execute all tests
        // You may need to increase this number once you add all 37 tests
        #1500; 

        // 3. Peek directly into the Register file (uut -> Register -> x[10])
        if (uut.Register.x[10] == 999) begin
            $display("========================================");
            $display(" SUCCESS: All 37 Instructions Passed!");
            $display("========================================");
        end else begin
            $display("========================================");
            $display(" FAILED at Test Number: %d", uut.Register.x[10]);
            $display("========================================");
        end

        $finish;
    end
endmodule
