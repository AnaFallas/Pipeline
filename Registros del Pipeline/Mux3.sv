module Mux3(input [2:0] data_in, input [1:0] select, output reg out);

always @* begin
    case (select)
        2'b00: out = data_in[0];
        2'b01: out = data_in[1];
        2'b10: out = data_in[2];
        default: out = 1'bx; // En caso de que el selector esté fuera de rango
    endcase
end

endmodule
