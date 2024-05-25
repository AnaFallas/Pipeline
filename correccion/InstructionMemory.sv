module InstructionMemory #(parameter size = 64) (
    input logic [63:0] adr,
    output logic [31:0] Instruction
);

    logic [31:0] Memory [size-1:0];

    initial begin
        Memory[0] = 8'hE5;
        Memory[1] = 8'h03;
        Memory[2] = 8'h1F;
        Memory[3] = 8'h8B;

        Memory[4] = 8'hA4;
        Memory[5] = 8'h00;
        Memory[6] = 8'h40;
        Memory[7] = 8'hF8;

        Memory[8] = 8'h86;
        Memory[9] = 8'h00;
        Memory[10] = 8'h04;
        Memory[11] = 8'h8B;

        Memory[12] = 8'hA6;
        Memory[13] = 8'h10;
        Memory[14] = 8'h00;
        Memory[15] = 8'hF8;

        /*Memory[0] = 8'h03;
        Memory[1] = 8'h21;
        Memory[2] = 8'h00;
        Memory[3] = 8'h00;

        Memory[4] = 8'hB3;
        Memory[5] = 8'h00;
        Memory[6] = 8'h21;
        Memory[7] = 8'h00;

        Memory[8] = 8'h23;
        Memory[9] = 8'h26;
        Memory[10] = 8'h10;
        Memory[11] = 8'h00;

        Memory[12] = 8'h83;
        Memory[13] = 8'h21;
        Memory[14] = 8'hC0;
        Memory[15] = 8'h00;*/
    end

    assign Instruction[7:0] = Memory[adr + 0]; 
    assign Instruction[15:8] = Memory[adr + 1];
    assign Instruction[23:16] = Memory[adr + 2];
    assign Instruction[31:24] = Memory[adr + 3];

endmodule
