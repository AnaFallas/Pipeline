module comparador (
    input logic dato_rs1,
    input logic dato_rs2,
    output logic resultado
);
assing resultado = (dato_rs1==dato_rs2) ? 1'b1 : 1'b0;


endmodule