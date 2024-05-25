module DataMemory (
    input logic [63:0] adr,     // dirección de Memoria
    input logic [63:0] datain,  // contenido dirección de Memoria
    input logic w, r,
    input logic clk,
    output logic [63:0] dataout
);

    logic [7:0] MEMO[31:0];

    /*integer i;
    initial begin
        for (i = 0; i < 255; i = i + 1)
            MEMO[i] = i;
    end*/

    always_ff @(posedge clk) begin
        if (w) begin
            MEMO[adr + 7] <= datain[63:56];
            MEMO[adr + 6] <= datain[55:48];
            MEMO[adr + 5] <= datain[47:40];
            MEMO[adr + 4] <= datain[39:32];
            MEMO[adr + 3] <= datain[31:24];
            MEMO[adr + 2] <= datain[23:16];
            MEMO[adr + 1] <= datain[15:8];
            MEMO[adr] <= datain[7:0];
        end
    end

    assign dataout = (r) ? {
        MEMO[adr + 7],
        MEMO[adr + 6],
        MEMO[adr + 5],
        MEMO[adr + 4],
        MEMO[adr + 3],
        MEMO[adr + 2],
        MEMO[adr + 1],
        MEMO[adr]
    } : 64'bz;

endmodule




 /*   logic [63:0] MEMO [7:0]; // Tamaño de la memoria ajustado

    initial begin
        MEMO[0]=64'd15;
        MEMO[1]=64'd10;
        MEMO[2]=64'd100;
    end

    always_ff @(posedge clk) begin
        if (w) begin
            MEMO[adr] <= datain;
        end
    end

    assign dataout = (r) ? MEMO[adr] : 8'bz;

endmodule*/
