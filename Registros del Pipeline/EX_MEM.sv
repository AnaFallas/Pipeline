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
//Declaracion de registros
    reg Rg_RegWrite_Out;
    reg Rg_MemtoReg_Out;
    reg Rg_MemWrite_Out;


    reg [63:0] Rg_ALUOut;
    reg [63:0] Rg_DatOut;
    reg [4:0] Rg_Rd_out;

always_ff @(posedge clk ) begin
    if (reset) begin
    // Inicializar las señales de control a cero en caso de reset
        Rg_RegWrite_Out <= 1'b0;
        Rg_MemtoReg_Out <= 1'b0;
        Rg_MemWrite_Out <= 1'b0;

     // Inicializar los datos a cero en caso de reset
        Rg_ALUOut  <= 64'b0;
        Rg_DatOut <= 64'b0;
        Rg_Rd_out  <= 5'b0;

    end else begin 
    //valores de control a la salida
        Rg_RegWrite_Out <= RegWrite;
        Rg_MemtoReg_Out <= MemtoReg;
        Rg_MemWrite_Out <= MemWrite;

    //valores de datos a la salida
        Rg_ALUOut  <= AluResult;
        Rg_DatOut <= Datain;
        Rg_Rd_out <= Rd_in;

    end

    end
    //señales
    assign RegWrite_Out = Rg_RegWrite_Out;
    assign MemtoReg_Out = Rg_MemtoReg_Out;
    assign MemWrite_Out = Rg_MemWrite_Out;
    //datos
    assign AluOut = Rg_ALUOut;
    assign DataOut = Rg_DatOut;
    assign Rd_out= Rg_Rd_out;
endmodule