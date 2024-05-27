`timescale 1ns/1ns
`include "MEM_WB.sv"

module MEM_WB_tb;

    // Parámetros de simulación
    localparam CLK_PERIOD = 10; // Período de reloj en unidades de tiempo

    // Señales de entrada
    logic clk;
    logic reset;
    logic RegWrite;
    logic MemtoReg;
    logic [63:0] Dataout_Memory;
    logic [63:0] AluOut_in;
    logic [4:0] Rd_in;

    // Señales de salida
    logic RegWrite_Out;
    logic MemtoReg_Out;
    logic [63:0] DataOut;
    logic [63:0] AluOut;
    logic [4:0] Rd_out;

    // Instancia del módulo bajo prueba
    MEM_WB uut (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .Dataout_Memory(Dataout_Memory),
        .AluOut_in(AluOut_in),
        .Rd_in(Rd_in),
        .RegWrite_Out(RegWrite_Out),
        .MemtoReg_Out(MemtoReg_Out),
        .DataOut(DataOut),
        .AluOut(AluOut),
        .Rd_out(Rd_out)
    );

    // Generación de reloj
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Inicialización
    initial begin
        $dumpfile("MEM_WB.vcd");
        $dumpvars(5, uut);

        // Inicializar señales
        clk = 1;
        reset = 0;
        RegWrite = 0;
        MemtoReg = 0;
        Dataout_Memory = 64'h0000000000000000;
        AluOut_in = 64'h0000000000000000;
        Rd_in = 5'b00000;

        // Esperar un poco después del reset
        #10;
        reset = 0;

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Mostrar resultados
        $display("RegWrite_Out = %b", RegWrite_Out);
        $display("MemtoReg_Out = %b", MemtoReg_Out);
        $display("DataOut = %h", DataOut);
        $display("AluOut = %h", AluOut);
        $display("Rd_out = %h", Rd_out);

        // Finalizar simulación
        $finish;
    end

endmodule
