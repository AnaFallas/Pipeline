module immgen(
	input logic [31:0] instr,
	input logic [1:0] ImmSrc,
	output logic [63:0] Out
);


always @(*) begin 
case (ImmSrc)
	2'b00: //tipo I 
        Out= {{52{instr[31]}}, instr [31:20]};
    2'b01: //tipo S 
        Out= {{52{instr[31]}}, instr [31:25], instr[11:7]};
    2'b10: //tipo B
        Out= {{53{instr[31]}}, instr [7], instr[30:25], instr [11:8]};
    default: begin
        Out = 64'b0;
        end
endcase
end 
endmodule