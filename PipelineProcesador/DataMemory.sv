module DataMemory (
    input logic [63:0] adr,     // dirección de Memoria
    input logic [63:0] datain,  // contenido dirección de Memoria
    input logic w , r,
    input logic clk,
    output logic [63:0] dataout
);

    logic [7:0] MEMO [31:0]; // Tamaño de la memoria ajustado

    logic bandera = 1;
    
    assign dataout = (r) ? { 
        MEMO[adr + 7],
        MEMO[adr + 6],
        MEMO[adr + 5],
        MEMO[adr + 4],
        MEMO[adr + 3],
        MEMO[adr + 2],
        MEMO[adr + 1],
        MEMO[adr] }  : 64'bz;
    
    always_ff @(posedge clk) begin
        if(bandera==0) begin
            MEMO[0]=20;
        MEMO[2]=50;
        MEMO[12]=100;
        bandera=1;
        end else begin
        if (w == 1'b1) begin
            { 
            MEMO[adr + 7] ,
            MEMO[adr + 6] ,
            MEMO[adr + 5] ,
            MEMO[adr + 4] ,
            MEMO[adr + 3] ,
            MEMO[adr + 2] ,
            MEMO[adr + 1] ,
            MEMO[adr]     
            } <= datain;


        end
        end
    end

endmodule