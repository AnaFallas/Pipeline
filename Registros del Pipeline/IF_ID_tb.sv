`timescale 1ns/1ns
`include "IF_ID.sv"

module IF_ID_tb;

    // Parámetros de simulación
    localparam CLK_PERIOD = 10; // Período de reloj en unidades de tiempo

    // Señales de entrada
    logic clk;
    logic rst;
    logic [31:0] instruction_in;
    logic [63:0] pc;
    logic PCSrcD_Control;
    logic flush;

    // Señales de salida
    logic [31:0] instruction_out;
    logic [63:0] out_pc;

    // Instancia del módulo bajo prueba
    IF_ID uut (
        .clk(clk),
        .rst(rst),
        .instruction_in(instruction_in),
        .pc(pc),
        .PCSrcD_Control(PCSrcD_Control),
        .flush(flush),
        .instruction_out(instruction_out),
        .out_pc(out_pc)
    );

    // Generación de reloj
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Inicialización
    initial begin
        $dumpfile("IF_ID.vcd");
        $dumpvars(5, uut);

        // Inicializar señales
        clk = 1;
        rst = 0;
        instruction_in = 32'h00000000;
        pc = 64'h0000000000000000;
        PCSrcD_Control = 0;
        flush = 0;

        // Esperar un poco después del reset
        #10;
        rst = 0;

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Inyectar datos de entrada
        instruction_in = 32'h11223344;
        pc = 64'h1234567890ABCDEF;
        PCSrcD_Control = 1;
        flush = 0;

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Mostrar resultados
        $display("instruction_out = %h", instruction_out);
        $display("out_pc = %h", out_pc);



        // Finalizar simulación
        $finish;
    end

endmodule
