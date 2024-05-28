`timescale 1ns/1ns
`include "Adder.sv"


module Adder_tb;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo del reloj en unidades de tiempo
    
    // Señales
    logic [63:0] a, b, out;
    logic clk = 0;

    // Instancia del módulo Adder
    Adder dut (
        .a(a),
        .b(b),
        .out(out)
    );

    // Generación de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Generación de estímulos
    initial begin
        // Inicialización de las entradas
        a = 32'h0000_0000_0000_0001;
        b = 32'h0000_0000_0000_0002;

        // Aplicación de estímulos
        #10 a = 32'h0000_0000_0000_0003;
        #10 b = 32'h0000_0000_0000_0004;

        // Detener la simulación después de aplicar los estímulos
        #10 $finish;
    end

    // Dump de las señales en un archivo VCD
    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, dut);
        #1; // Retraso inicial para asegurar que todas las variables se capturen correctamente
    end

endmodule

