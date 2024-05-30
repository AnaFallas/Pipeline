`timescale 1ns/1ns 
`include "Clock.sv"
`default_nettype none

module Clock_tb;

    // Definición de señal de reloj
    reg CLK;

    // Instancia del módulo Clock bajo prueba
    Clock uut (
        .CLK(CLK)
    );

    // Generación de estímulos
    initial begin
        // Inicializa la simulación
        $dumpfile("Clock.vcd");
        $dumpvars(0, uut);
        #10; // Espera un pequeño tiempo para estabilizar la simulación

        // Finaliza la simulación después de un cierto tiempo
        #200; 
        $finish;
    end

endmodule


