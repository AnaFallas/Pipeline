module Hazard_U(
    input logic [4:0] R_d,
    input logic MemRead,
    input logic [31:0] Instruction, 

    output logic SignalPC//deshabilita el PC para que no cambie / deshabilita el registro IF/ID para que mantenga la instruccion / se usa como control del mux
);
  
initial begin
    SignalPC= 1'b0;
end
  
always @(*) begin
    if (MemRead && ((RD == Instruction[19:15]) || (RD == Instruction[24:20])))
        SignalPC= 1'b1;
    else
        SignalPC= 1'b0;
end
endmodule