module Multiplexor (
    input logic [63:0] a,
    input logic [63:0] b,
    input logic select,
    output logic [63:0] result
);
    assign result = (select) ? b : a;
endmodule
