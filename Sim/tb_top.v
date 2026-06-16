`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2026 00:35:37
// Design Name: 
// Module Name: tb_top
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

module top_tb;

    // 1. Declare the test wires
    reg clk;
    reg rst;

    // 2. Instantiate your CPU
    top uut (
        .clk(clk),
        .rst(rst)
    );

    // 3. Clock Generator (100MHz)
    always #5 clk = ~clk;

    // 4. The Test Sequence with Automatic Console Logging
    initial begin
        // Start with reset active
        clk = 0;
        rst = 1;
        #10;
        
        // Release reset to let the program run
        rst = 0;

        // Wait 100ns to give the 3 addition instructions plenty of time to finish
        #100;

        // --- CONSOLE LOGGING BLOCK ---
        // We dive straight into the hardware hierarchy: uut -> Register module -> x array
        $display("\n==================================================");
        $display("          RISC-V CPU SIMULATION REPORT            ");
        $display("==================================================");
        $display(" TIME         : %0d ns", $time);
        $display(" Instruction 1: ADDI x11, x0, 5  -> x11 = %d", uut.Register.x[11]);
        $display(" Instruction 2: ADDI x12, x0, 6  -> x12 = %d", uut.Register.x[12]);
        $display("--------------------------------------------------");
        $display(" Instruction 3: ADD  x13, x11, x12 -> x13 = %d (SUM)", uut.Register.x[13]);
        $display("==================================================\n");

        // Stop the simulation
        $finish;
    end

endmodule
 
