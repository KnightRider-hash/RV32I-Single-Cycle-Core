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
    wire       pc_src;
    
    // --- Datapath Wires ---
    wire [31:0] imm_ext;
    wire [31:0] rd1, rd2;       
    wire [31:0] alu_in_b;
    wire [31:0] alu_result;     
    wire        zero_flag;      
    wire [31:0] read_data;      // Formatted data coming OUT of RAM (via load_ext)
    wire [31:0] result_wire;    // The final data entering the Register File
    
    // --- Memory Wires ---
    wire [31:0] ram_read_data;  // Raw 32-bit data directly out of RAM
    wire [3:0]  M;              // Memory write mask from sw.v
    wire [31:0] o;              // Formatted data from sw.v going INTO RAM

    // --- Datapath Assignments ---
    // --- Branch Evaluation Logic ---
    wire take_branch = branch & (
        (instr[14:12] == 3'b000 & zero_flag == 1'b1) |  // BEQ: Branch if Equal
        (instr[14:12] == 3'b001 & zero_flag == 1'b0)    // BNE: Branch if Not Equal
    );
    
    assign pc_src = jump | take_branch;
    assign alu_in_b = (alu_src == 1'b1) ? imm_ext : rd2;

    // Result Multiplexer (00: ALU, 01: Memory, 10: PC+4)
    assign result_wire = (result_src == 2'b01) ? read_data :
                         (result_src == 2'b10) ? (pc_current + 32'd4) : alu_result; 

    // 1. Program Counter
    pc program_counter (
        .clk(clk),
        .rst(rst),
        .pcsrc(pc_src),       
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
        .rd(reg_write),         
        .src1(instr[19:15]),    
        .src2(instr[24:20]),    
        .dest(instr[11:7]),     
        .rs(result_wire),       
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
        .B(alu_in_b),           
        .OP(alu_control),
        .z(zero_flag),
        .c(),                   
        .negative(),            
        .out(alu_result)
    );

    // 7. Store Logic (Formats data going INTO RAM for SB, SH, SW)
    sw store_logic(
        .dat_in(rd2),                  
        .funct3(instr[14:12]),         
        .aluo(alu_result[1:0]),        
        .out(o),           
        .mask(M)                       
    );

    // 8. Data Memory (RAM)
    ram data_memory (
        .clk(clk),
        .memrd(mem_read),
        .mask({4{mem_write}} & M),     // Only apply the mask if mem_write is high!
        .adr(alu_result),        
        .dain(o),                      
        .daout(ram_read_data)    
    );

    // 9. Load Extension (Formats data coming OUT of RAM for LB, LH, LW, LBU, LHU)
    load_ext load_formatter(
        .ram_in(ram_read_data),
        .funct3(instr[14:12]),
        .aluo(alu_result[1:0]),
        .reg_out(read_data)
    );

endmodule


