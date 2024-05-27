`timescale 1ns/1ns
`include "ID_EX.sv"

module ID_EX_tb;

    // Parámetros de simulación
    localparam CLK_PERIOD = 10; // Período de reloj en unidades de tiempo

    // Señales de entrada
    logic clk;
    logic rst;
    logic AluSrc_in;
    logic MemtoReg_in;
    logic RegWrite_in;
    logic MemRead_in;
    logic MemWrite_in;
    logic [1:0] Aluop_in;
    logic [63:0] rs1Data_in;
    logic [63:0] rs2Data_in;
    logic [4:0] rs_in;
    logic [4:0] rt_in;
    logic [4:0] rd_in;
    logic [63:0] immediate_in;
    
    // Señales de salida
    logic AluSrc_out;
    logic MemtoReg_out;
    logic RegWrite_out;
    logic MemRead_out;
    logic MemWrite_out;
    logic [1:0] Aluop_out;
    logic [63:0] rs1Data_out;
    logic [63:0] rs2Data_out;
    logic [4:0] rs_out;
    logic [4:0] rt_out;
    logic [4:0] rd_out;
    logic [63:0] immediate_out;

    // Instancia del módulo bajo prueba
    ID_EX uut (
        .clk(clk),
        .rst(rst),
        .AluSrc_in(AluSrc_in),
        .MemtoReg_in(MemtoReg_in),
        .RegWrite_in(RegWrite_in),
        .MemRead_in(MemRead_in),
        .MemWrite_in(MemWrite_in),
        .Aluop_in(Aluop_in),
        .rs1Data_in(rs1Data_in),
        .rs2Data_in(rs2Data_in),
        .rs_in(rs_in),
        .rt_in(rt_in),
        .rd_in(rd_in),
        .immediate_in(immediate_in),
        .AluSrc_out(AluSrc_out),
        .MemtoReg_out(MemtoReg_out),
        .RegWrite_out(RegWrite_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .Aluop_out(Aluop_out),
        .rs1Data_out(rs1Data_out),
        .rs2Data_out(rs2Data_out),
        .rs_out(rs_out),
        .rt_out(rt_out),
        .rd_out(rd_out),
        .immediate_out(immediate_out)
    );

    // Generación de reloj
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Inicialización
    initial begin
        $dumpfile("ID_EX.vcd");
        $dumpvars(5, uut);

        // Inicializar señales
        clk = 1;
        rst = 0;
        AluSrc_in = 0;
        MemtoReg_in = 0;
        RegWrite_in = 0;
        MemRead_in = 0;
        MemWrite_in = 0;
        Aluop_in = 2'b00;
        rs1Data_in = 64'h0000000000000000;
        rs2Data_in = 64'h0000000000000000;
        rs_in = 5'b00000;
        rt_in = 5'b00000;
        rd_in = 5'b00000;
        immediate_in = 64'h0000000000000000;

        // Esperar un poco después del reset
        #10;
        rst = 0;

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Mostrar resultados
        $display("AluSrc_out = %b", AluSrc_out);
        $display("MemtoReg_out = %b", MemtoReg_out);
        $display("RegWrite_out = %b", RegWrite_out);
        $display("MemRead_out = %b", MemRead_out);
        $display("MemWrite_out = %b", MemWrite_out);
        $display("Aluop_out = %b", Aluop_out);
        $display("rs1Data_out = %h", rs1Data_out);
        $display("rs2Data_out = %h", rs2Data_out);
        $display("rs_out = %h", rs_out);
        $display("rt_out = %h", rt_out);
        $display("rd_out = %h", rd_out);
        $display("immediate_out = %h", immediate_out);

        // Finalizar simulación
        $finish;
    end

endmodule
