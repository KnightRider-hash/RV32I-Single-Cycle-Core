`timescale 1ns / 1ps

module Cu(
    input [6:0] opcode,
    input [2:0] funct3,
    input funct7,
    
    // --- NEW ALU FLAG INPUTS ---
    input zero,
    input negative,
    input carry,
    
    // --- UPDATED OUTPUTS ---
    output reg Rgwrite,
    output reg pc_src,      // Replaced 'branch' and 'jump'
    output reg alusrc,
    output reg memread,
    output reg memwrite,
    output reg [1:0] memtreg,
    output reg [1:0] aluop,
    output reg [1:0] immsrc,
    output reg [3:0] op,
    output reg forward_pc,  // Flips the AUIPC switch
    output reg jalr_sel   // Flips the JALR switch
 );

 always@(*) begin
    // 1. DEFAULT STATES (Everything off by default)
    Rgwrite  = 1'b0;
    pc_src   = 1'b0; 
    alusrc   = 1'b0;
    memread  = 1'b0;
    memwrite = 1'b0;
    memtreg  = 2'b00;
    aluop    = 2'b00;
    immsrc   = 2'b00;
    forward_pc=1'b0;
    jalr_sel=1'b0;
 
    // 2. INSTRUCTION DECODER
    case(opcode)
        7'b0110011: begin   // R-type
            Rgwrite = 1'b1;
            aluop = 2'b10;
        end
        
        7'b0010011: begin  // I-type Math
            Rgwrite = 1'b1;
            aluop = 2'b10;
            alusrc = 1'b1;
        end
        
        7'b0000011: begin   // I-type Load (LW)
            Rgwrite = 1'b1;
            memread = 1'b1;
            alusrc = 1'b1;
            memtreg = 2'b01;
        end
        
        7'b0100011: begin   // S-type (SW)
            memwrite = 1'b1;
            alusrc = 1'b1;
            immsrc = 2'b01;
        end
        
        7'b1100011: begin  // B-type (ALL 6 BRANCHES!)
            aluop = 2'b01; // Force ALU to subtract
            immsrc = 2'b10;
            
            // The Branch Evaluator
            case(funct3)
                3'b000: pc_src = zero;          // BEQ
                3'b001: pc_src = ~zero;         // BNE
                3'b100: pc_src = negative;      // BLT
                3'b101: pc_src = ~negative;     // BGE
                3'b110: pc_src = ~carry;        // BLTU
                3'b111: pc_src = carry;         // BGEU
                default: pc_src = 1'b0;
            endcase
        end
        
        7'b0110111: begin   // U-type (LUI)
            Rgwrite = 1'b1;
            alusrc = 1'b1;
            immsrc = 2'b11;
        end
        
        7'b0010111: begin   // U-type (AUIPC) - Added this for you!
            Rgwrite = 1'b1;
            alusrc = 1'b1;
            immsrc = 2'b11;
           forward_pc=1'b1;
          end
        
        7'b1101111: begin  // J-type (JAL)
            Rgwrite = 1'b1;
            pc_src = 1'b1; // Always jump!
            memtreg = 2'b10;
            immsrc = 2'b11;
        end
        
        7'b1100111: begin  // I-type (JALR)
            Rgwrite = 1'b1;
            pc_src = 1'b1; // Always jump!
            alusrc = 1'b1;
            memtreg = 2'b10;
            immsrc = 2'b00;
            jalr_sel=1'b1;
        end
    endcase 

    // 3. ALU OPERATION DECODER (Untouched, perfectly handles ADDI bug)
    case(aluop)
        2'b00: op=4'b0000; // ADD (Loads, Stores, U-types)
        2'b01: op=4'b0001; // SUB (Branches)
        2'b10: case(funct3) // R-TYPE & I-TYPE
            3'b000: begin
                if(opcode==7'b0110011 && funct7 == 0)
                    op=4'b0000; // ADD r
                else if(opcode==7'b0010011)
                    op=4'b0000; // ADD i
                else 
                    op=4'b0001; // SUB r
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
