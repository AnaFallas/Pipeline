module SumaC2 #(
parameter ANCHO = 64
)
(
    input logic [ANCHO - 1 : 0]   a,
    input logic [ANCHO - 1 : 0]   b,
    input logic ci,
    output logic [ANCHO-1:0] s,
    output logic coutfin

);

logic Cout_prima;
logic des;

always_comb begin
    
    {Cout_prima,s [ANCHO-2:0]} = a [ANCHO-2:0] + b [ANCHO-2:0] + ci;

    {coutfin,s [ANCHO-1]} = a [ANCHO-1] + b [ANCHO-1] + Cout_prima;

    des = coutfin ^ Cout_prima;
    

end




endmodule