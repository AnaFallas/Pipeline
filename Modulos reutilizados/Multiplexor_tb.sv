`include "Multiplexor.sv"
`timescale 1ns/1ns 

module Multiplexor_tb;

    // Parámetros
    parameter WIDTH = 64; // Ancho de los datos
    parameter SIM_TIME = 100; // Tiempo total de simulación

    // Definición de señales
    logic [WIDTH-1:0] a, b;
    logic select;
    logic [WIDTH-1:0] result;

    // Instancia del módulo Multiplexor bajo prueba
    Multiplexor uut (
        .a(a),
        .b(b),
        .select(select),
        .result(result)
    );

    // Generación de estímulos
    initial begin
         $dumpfile("Multiplexor_tb.vcd");
        $dumpvars(5, uut);
        // Inicialización de señales
        a = 64'h123456789ABCDEF0;
        b = 64'hFFFFFFFFFFFFFFFF;
        select = 1'b0;

        // Cambio de señales después de cierto tiempo
        #10;
        select = 1'b1;

        #10;
        select = 1'b0;

        // Otros cambios de señales pueden ser añadidos aquí

        // Terminar simulación después de un cierto tiempo
        #SIM_TIME;
        $finish;
    end

    // Monitoreo de salidas
    always @(select) begin
        $display("select = %b, a = %h, b = %h, result = %h", select, a, b, result);
    end

endmodule
