module ControlUnit (
    input [6:0] OpCode,
    
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] Aluop,
    output reg MemWrite,
    output reg AluSrc,
    output reg RegWrite
);

    reg [7:0] outcome;

    always_comb begin
        {AluSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch} = outcome[7:2];
        Aluop = outcome[1:0];
    end

    always_ff @(OpCode) begin
        case(OpCode)
            7'b0110011: outcome = 8'b00100010;  //tipo r
            7'b0000011: outcome = 8'b11110000;  // load
            7'b0100011: outcome = 8'b10001000;  //store
            7'b1100011: outcome = 8'b00000101;  //branch
            7'b0000000: outcome = 8'b00000000;
            default: outcome = 8'b0; // Default 
        endcase
    end
endmodule
