`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 19:53:39
// Design Name: 
// Module Name: top
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
module top(
    input clk,
    input rst
);


    // --- Program Counter & Memory Wires ---
    wire [31:0] pc_current;
    wire [31:0] instr;
    
    // --- Control Unit Wires ---
    wire       reg_write, alu_src, mem_read, mem_write, branch, jump;
    wire [1:0] result_src, imm_src, alu_op;
    wire [3:0] alu_control;
    wire       pc_src; // The final wire that tells the PC to jump
    
    // --- Datapath Wires ---
    wire [31:0] imm_ext;
    wire [31:0] rd1, rd2;       // Outputs from Register File
    wire [31:0] alu_in_b;       // Input B into the ALU
    wire [31:0] alu_result;     // Output from ALU
    wire        zero_flag;      // Zero flag from ALU
    wire [31:0] read_data;      // Output from Data RAM
    wire [31:0] result_wire;    // The final data going back to the Register File


   
assign pc_src = jump | (branch & zero_flag);

assign alu_in_b = (alu_src==1)? imm_ext:rd2;

assign result_wire =(result_src==1)?read_data:
                    (result_src == 2'b10)?(pc_current + 32'd4):alu_result; // to do everything in single cycle pc+4 needed
    
    // 1. Program Counter
    pc program_counter (
        .clk(clk),
        .rst(rst),
        .pcsrc(pc_src),       // Connected to our Branch Logic gate!
        .imm(imm_ext),
        .adr(pc_current)
    );

    // 2. Instruction Memory
    instr_mem rom (
        .adr(pc_current),
        .instr(instr)
    );

    // 3. Control Unit
    Cu control_unit (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[30]),
        .Rgwrite(reg_write),
        .branch(branch),
        .alusrc(alu_src),
        .memread(mem_read),
        .memwrite(mem_write),
        .jump(jump),
        .memtreg(result_src),
        .aluop(alu_op),
        .immsrc(imm_src),
        .op(alu_control)
    );

    // 4. Register File
   registers Register (
        .clk(clk),
        .rd(reg_write),         // Write Enable from CU
        .src1(instr[19:15]),    // rs1 address
        .src2(instr[24:20]),    // rs2 address
        .dest(instr[11:7]),     // rd address (Destination)
        .rs(result_wire),       // Write Data (From our Result MUX)
        .data1(rd1),
        .data2(rd2)
    );

    // 5. Immediate Generator
    imm_gen immediate_gen (
        .immsrc(imm_src),
        .instr(instr),
        .result(imm_ext)
    );

    // 6. ALU
    ALU_n_bit #(.n(31)) alu (
        .A(rd1),
        .B(alu_in_b),           // Comes from the ALU Source MUX
        .OP(alu_control),
        .z(zero_flag),
        .c(),                   // Leaving blank because RISC-V branches don't use carry!
        .negative(),            // Leaving blank
        .out(alu_result)
    );

    // 7. Data Memory (RAM)
    ram data_memory (
        .clk(clk),
        .memrd(mem_read),
        .memwr(mem_write),
        .adr(alu_result),       // ALU calculates the memory address
        .dain(rd2),             // Data to store comes straight from Register 2
        .daout(read_data)
    );

endmodule


