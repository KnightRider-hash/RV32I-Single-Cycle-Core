module load_ext(
    input  wire [31:0] ram_in,
    input  wire [2:0]  funct3,
    input  wire [1:0]  aluo,
    output reg  [31:0] reg_out
);

    reg [7:0]  R_byte;
    reg [15:0] R_half; 

    always @(*) begin
        // STEP 1: The Slicer
        case(aluo)
            2'b00: begin
                R_byte = ram_in[7:0];
                R_half = ram_in[15:0];
            end
            2'b01: begin
                R_byte = ram_in[15:8];
                R_half = 16'b0; // Prevent inferred latch!
            end
            2'b10: begin
                R_byte = ram_in[23:16]; // Fixed 8-bit width
                R_half = ram_in[31:16];
            end
            2'b11: begin
                R_byte = ram_in[31:24]; // Fixed 8-bit width
                R_half = 16'b0; // Prevent inferred latch!
            end
        endcase
        
        // STEP 2: The Padder
        case(funct3)
            3'b000: reg_out = { {24{R_byte[7]}}, R_byte }; // LB
            3'b001: reg_out = { {16{R_half[15]}}, R_half }; // LH
            3'b010: reg_out = ram_in;                      // LW
            3'b100: reg_out = { 24'b0, R_byte };           // LBU
            3'b101: reg_out = { 16'b0, R_half };           // LHU
            default: reg_out = 32'b0;
        endcase
    end

endmodule