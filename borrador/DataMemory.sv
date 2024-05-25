module DataMemory (
    input logic [63:0] adr,     // dirección de Memoria
    input logic [63:0] datain,  // contenido dirección de Memoria
    input logic w, r,
    input logic clk,
    output logic [63:0] dataout
);


    logic [63:0] MEMO [7:0]; // Tamaño de la memoria ajustado

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

endmodule
