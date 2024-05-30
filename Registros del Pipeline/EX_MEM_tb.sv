`timescale 1ns/1ns
`include "EX_MEM.sv"

module EX_MEM_tb;

    // Parámetros de simulación 2
    localparam CLK_PERIOD = 10; // Período de reloj en unidades de tiempo

    // Señales de entrada
    logic clk;
    logic reset;
    logic RegWrite;
    logic MemtoReg;
    logic MemWrite;

    logic [63:0] AluResult;
    logic [63:0] Datain;
    logic [4:0] Rd_in;

    // Señales de salida
    logic RegWrite_Out;
    logic MemtoReg_Out;
    logic MemWrite_Out;
  
    logic [63:0] AluOut;
    logic [63:0] DataOut;
    logic [4:0] Rd_out;

    // Instancia del módulo bajo prueba
    EX_MEM uut (
        .clk(clk),
        .reset(reset),

        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
     
        .AluResult(AluResult),
        .Datain(Datain),
        .Rd_in(Rd_in),

        .RegWrite_Out(RegWrite_Out),
        .MemtoReg_Out(MemtoReg_Out),
        .MemWrite_Out(MemWrite_Out),
       

        .AluOut(AluOut),
        .DataOut(DataOut),
        .Rd_out(Rd_out)
    );

    // Generación de reloj
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Inicialización
    initial begin
        $dumpfile("EX_MEM.vcd");
        $dumpvars(5, uut);

        // Inicializar señales
        clk = 1;
        reset = 0;

        RegWrite = 0;
        MemtoReg = 0;
        MemWrite = 0;
 
        AluResult = 64'h0000000000000000;
        Datain = 64'h0000000000000000;
        Rd_in = 5'b00000;

        // Esperar un poco después del reset
        #10;
        reset = 0;

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Mostrar resultados
        $display("RegWrite_Out = %b", RegWrite_Out);
        $display("MemtoReg_Out = %b", MemtoReg_Out);
        $display("MemWrite_Out = %b", MemWrite_Out);
       
       
        $display("AluOut = %h", AluOut);
        $display("DataOut = %h", DataOut);
        $display("Rd_out = %h", Rd_out);

        // Finalizar simulación
        
        $finish;
    end

endmodule
