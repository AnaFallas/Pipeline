module Mux3  (    
    input logic [63:0] a,
    input logic [63:0] b,    
    input logic [63:0] c,
    input logic [1:0] select,    
    output logic [63:0] result
);
always_comb begin    
    case (select)
        2'b00: result = a;        
        2'b01: result = b;
        2'b10: result = c;        
        default: result = 'z; // Manejo de caso para selección fuera de rango
    endcase
    end
endmodule
