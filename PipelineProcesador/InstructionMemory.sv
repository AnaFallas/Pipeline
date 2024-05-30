module InstructionMemory #(parameter size = 64) (
    input logic [63:0] adr,
    output logic [31:0] Instruction
);

    logic [31:0] Memory [size-1:0];

    initial begin
     

        Memory[0] = 8'hB3;
        Memory[1] = 8'h01;
        Memory[2] = 8'h41;
        Memory[3] = 8'h00;

        Memory[4] = 8'hB3;
        Memory[5] = 8'h82;
        Memory[6] = 8'h81;
        Memory[7] = 8'h40;

        Memory[4] = 8'h83;
        Memory[5] = 8'ha4;
        Memory[6] = 8'h42;
        Memory[7] = 8'h06;

        Memory[8] = 8'h23;
        Memory[9] = 8'hA0;
        Memory[10] = 8'h74;
        Memory[11] = 8'h00;

        Memory[12] = 8'h83;
        Memory[13] = 8'hA3;
        Memory[14] = 8'h40;
        Memory[15] = 8'h01;

        Memory[16] = 8'hB3;
        Memory[17] = 8'h01;
        Memory[18] = 8'h52;
        Memory[19] = 8'h00;

        Memory[20] = 8'hB3;
        Memory[21] = 8'h02;
        Memory[22] = 8'h34;
        Memory[23] = 8'h40;

        Memory[24] = 8'hE3;
        Memory[25] = 8'h88;
        Memory[26] = 8'h50;
        Memory[27] = 8'hFE;

       


    
    end

    assign Instruction[7:0] = Memory[adr + 0]; 
    assign Instruction[15:8] = Memory[adr + 1];
    assign Instruction[23:16] = Memory[adr + 2];
    assign Instruction[31:24] = Memory[adr + 3];

endmodule
