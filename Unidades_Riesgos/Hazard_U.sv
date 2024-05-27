module Hazard_U(
    input logic [4:0] R_d,
    input logic MemRead,
    input logic [31:0] Instruction, 

    output logic SignalPC
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