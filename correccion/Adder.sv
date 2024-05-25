module Adder(
    input logic [63:0] a,
    input logic [63:0] b,
    output logic [63:0] out
);

    assign out = a + b;

endmodule
