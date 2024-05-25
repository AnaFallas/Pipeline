module ControlUnit (
    input [6:0] OpCode,
    input [2:0] AluR,
    
    output reg AluSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] Aluop,
    output reg [1:0]Imm
);

    reg [9:0] outcome;

    always_comb begin
        {AluSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch} = outcome[9:4];
        Aluop= outcome [3:2];
        Imm = outcome[1:0];
    end

    always_ff @(OpCode) begin
        case(OpCode)
            7'b0110011: begin //type r
                case (AluR)
                3'b000: outcome =10'b001000_10_11;//add y sub
                3'b111: outcome =10'b001000_00_11;//and
                3'b110: outcome =10'b001000_01_11;//or
                endcase
            end
            7'b0000011: outcome = 10'b111100_10_00;  // load
            7'b0100011: outcome = 10'b110110_10_01;  //store
            7'b1100011: outcome = 10'b000001_10_10;  //branch
            7'b0000000: outcome = 10'b000000_00_00;
            default: outcome = 8'b0; // Default 
        endcase
    end
endmodule
