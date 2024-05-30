module comparador (
    input logic [63:0] dato_rs1,
    input logic [63:0] dato_rs2,
    output logic resultado
);
assign resultado = (dato_rs1==dato_rs2) ? 1'b1 : 1'b0;


endmodule