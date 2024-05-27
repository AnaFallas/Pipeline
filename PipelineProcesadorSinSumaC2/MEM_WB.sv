
module MEM_WB (
    input logic clk,
    input logic reset,
    // Señales de entrada
    input logic  RegWrite,
    input logic MemtoReg,

    //Datos de entrada
    input logic [63:0] Dataout_Memory,
    input logic [63:0] AluOut_in,
    input logic [4:0] Rd_in,

    // Señales de salida
    output logic  RegWrite_Out,
    output logic MemtoReg_Out,

    //datos de salida 
    output logic [63:0] DataOut,
    output logic [63:0] AluOut,
    output logic [4:0] Rd_out

);

//Declaracion de registros
    reg Rg_RegWrite_Out;
    reg Rg_MemtoReg_Out;

    reg [63:0] Rg_DatOut;
    reg [63:0] Rg_ALUOut;
    reg [4:0] Rg_Rd_out;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
    // Inicializar las señales de control a cero en caso de reset
        Rg_RegWrite_Out <= 1'b0;
        Rg_MemtoReg_Out <= 1'b0;

     // Inicializar los datos a cero en caso de reset
        Rg_ALUOut  <= 64'b0;
        Rg_DatOut <= 64'b0;
        Rg_Rd_out  <= 5'b0;

    end else begin 
    //valores de control a la salida
        Rg_RegWrite_Out <= RegWrite;
        Rg_MemtoReg_Out <= MemtoReg;
        
    //valores de datos a la salida
        Rg_ALUOut <= AluOut_in;
        Rg_DatOut <= Dataout_Memory;
        Rg_Rd_out <= Rd_in;

    end

    end
    //señales
    assign RegWrite_Out = Rg_RegWrite_Out;
    assign MemtoReg_Out = Rg_MemtoReg_Out;
    //datos
    assign AluOut = Rg_ALUOut;
    assign DataOut = Rg_DatOut;
    assign Rd_out= Rg_Rd_out;

    
endmodule