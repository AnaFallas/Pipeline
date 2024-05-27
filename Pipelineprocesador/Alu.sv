module Alu(
    input logic [63:0] A, B,
    input logic [1:0] ALU_Sel,
    output logic [63:0] ALU_Out,
    output logic coutfin
    //output logic z 
    );

    logic [63:0] ALU_Result;
    //logic [63:0] Suma_Result; 
    assign ALU_Out = ALU_Result;

    logic Suma_coutfin;
    logic [63:0] Suma_s;

 
    SumaC2 #(
        .ANCHO(64) 
    ) Suma_inst (
        .a(A),
        .b(B),
        .ci(1'b0),
        .s(Suma_s),
        .coutfin(Suma_coutfin)
    );

    always_comb
    begin
       
        case (ALU_Sel)
            2'b00: ALU_Result = A & B;
            2'b01: ALU_Result = A | B;
            2'b10: ALU_Result = Suma_s;
            default: ALU_Result = 64'b0;
        endcase

       
       /* if (A == B)
            z = 1'b1;
        else
            z = 1'b0;*/
    end

    // Conexión de la salida coutfin con el carry-out de la suma
    assign coutfin = Suma_coutfin;

endmodule
