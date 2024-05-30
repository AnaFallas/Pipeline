module Hazard_U(
    input logic [4:0] R_d, //direccion de destino
    input logic MemRead,
    input logic [31:0] Instruction, //instrucción completa de la que se obtiene rs1 y rs2

    output logic SignalPC//desabilita el PC para que no cambie, deshabilita el registro IF/ID para que mantenga la instrucción se usa como control del mux 
);
  
initial begin
    SignalPC= 1'b0;
end
  
always @(*) begin
    if (MemRead && ((R_d == Instruction[19:15]) || (R_d == Instruction[24:20])))
        SignalPC= 1'b1;
    else
        SignalPC= 1'b0;
end
endmodule