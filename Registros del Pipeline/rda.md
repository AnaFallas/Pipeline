module ID_EX (
    input logic clk,
    input logic reset,
    // Señales de entrada
    input logic AluSrc,
    input logic  RegWrite,
    input logic MemtoReg,
    input logic MemWrite,
    input logic MemRead,
    input logic [1:0] Aluop,


    //Datos de entrada
    
    input logic [63:0] Rs1,
    input logic [63:0] Rs2,
    input logic [4:0] Rd_in,
    input logic [4:0] Rs1AD_in,
    input logic [4:0] Rs2AD_in,
    input logic [63:0] SignExtend,

    // Señales de salida
    output logic AluSrc_Out,
    output logic  RegWrite_Out,
    output logic MemtoReg_Out,
    output logic MemWrite_Out,
    output logic  MemRead_Out,
    output logic [1:0] Aluop_Out,

    //datos de salida 
    output logic [63:0] Rs1Out,
    output logic [63:0] Rs2Out,
    output logic [4:0] Rd_out,
    output logic [4:0] Rs1AD_Out,
    output logic [4:0] Rs2AD_Out,
    output logic [63:0] SignExtendOut


);
//Declaracion de registros
    reg Rg_AluSrc_Out;
    reg Rg_RegWrite_Out;
    reg Rg_MemtoReg_Out;
    reg Rg_MemWrite_Out;
    reg Rg_MemRead_Out;
    reg [1:0] Rg_AluOp_Out;

    reg [63:0] Rg_ALUOut;
    reg [63:0] Rg_DatOut;
    reg [4:0] Rg_Rd_out;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
    // Inicializar las señales de control a cero en caso de reset
        Rg_RegWrite_Out <= 0;
        Rg_MemtoReg_Out <= 0;
        Rg_MemWrite_Out <= 0;

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