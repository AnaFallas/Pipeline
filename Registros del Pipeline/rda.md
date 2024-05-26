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

    reg [63:0] Rg_Rs1Out;
    reg [63:0] Rg_Rs2Out;
    reg [4:0] Rg_Rd_out;
    reg [4:0] Rg_Rs1AD_out;
    reg [4:0] Rg_Rs2AD_out;
    reg [63:0] Rg_SignExtendOut;


always_ff @(posedge clk) begin
    if (reset) begin
    // Inicializar las señales de control a cero en caso de reset
        Rg_AluSrc_Out <= 1'b0;
        Rg_RegWrite_Out <= 1'b0;
        Rg_MemtoReg_Out <= 1'b0;
        Rg_MemWrite_Out <= 1'b0;
        Rg_MemRead_Out <= 1'b0;
        Rg_AluOp_Out <= 2'b00;

     // Inicializar los datos a cero en caso de reset
        Rg_Rs1Out <= 64'b0;
        Rg_Rs2Out <= 64'b0;
        Rg_Rd_out  <= 5'b0;
        Rg_Rs1AD_out <= 5'b0;
        Rg_Rs2AD_out <= 5'b0;
        Rg_SignExtendOut <= 64'b0;


    end else begin 
    //valores de control a la salida
        Rg_AluSrc_Out <= AluSrc ;
        Rg_RegWrite_Out <= RegWrite;
        Rg_MemtoReg_Out <= MemtoReg;

        Rg_MemWrite_Out <= MemWrite;
        Rg_MemRead_Out <= MemRead;
        Rg_AluOp_Out <=  Aluop;

    //valores de datos a la salida
        Rg_Rs1Out  <= Rs1;
        Rg_Rs2Out<= Rs2;
        Rg_Rd_out <= Rd_in;
        Rg_Rs1AD_out <= Rs1AD_in;
        Rg_Rs2AD_out <= Rs2AD_in;
        Rg_SignExtendOut <= SignExtend;


    end

    end
    //señales
    assign AluSrc_Out = Rg_AluSrc_Out ;
    assign RegWrite_Out = Rg_RegWrite_Out;
    assign MemtoReg_Out = Rg_MemtoReg_Out;

    assign MemWrite_Out = Rg_MemWrite_Out;
    assign MemRead_Out = Rg_MemRead_Out;
    assign AluOp_Out = Rg_AluOp_Out;
    
    //datos
    assign Rs1Out = Rg_Rs1Out;
    assign Rs2Out = Rg_Rs2Out;
    assign Rd_out = Rg_Rd_out;

    assign Rs1AD_out= Rg_Rs1AD_out;
    assign Rs2AD_out= Rg_Rs2AD_out;
    assign SignExtendOut= Rg_SignExtendOut;
endmodule