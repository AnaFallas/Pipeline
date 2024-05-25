module EX_MEM (
    input logic clk,
    input logic reset,
    // Señales de entrada
    input logic  RegWrite,
    input logic MemtoReg,
    input logic MemWrite,

    //Datos de entrada
    input logic [63:0] AluResult  ,
    input logic [63:0] Datain,
    input logic [4:0] Rd_in,

    // Señales de salida
    output logic  RegWrite_Out,
    output logic MemtoReg_Out,
    output logic MemWrite_Out,

    //datos de salida 
    output logic [63:0] AluOut,
    output logic [63:0] DataOut,
    output logic [4:0] Rd_out

);
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
    // Inicializar las señales de control a cero en caso de reset
        RegWrite_Out <= 0;
        MemtoReg_Out <= 0;
        MemWrite_Out <= 0;

     // Inicializar los datos a cero en caso de reset
        AluOut  <= 64'b0;
        DataOut <= 64'b0;
        Rd_out  <= 5'b0;


    end else begin 
    //valores de control a la salida
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
        MemWrite_out <= MemWrite;

    //valores de datos a la salida
        AluOut <= AluResult;
        DataOut <= Datain;
        Rd_out <= Rd_in;

    end

    end
    
endmodule