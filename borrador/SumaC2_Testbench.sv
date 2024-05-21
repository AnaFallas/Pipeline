`include "SumaC2.sv"
`timescale 1ns/1ns 
module SumaC2_Testbench;

    // Parámetros del testbench
    parameter WIDTH = 8; // Ancho de los operandos

    // Definición de señales
    logic [WIDTH-1:0] a, b;
    logic ci;
    logic [WIDTH-1:0] s;
    logic coutfin;

    // Instancia del módulo SumaC2 bajo prueba
    SumaC2 #(
        .ANCHO(WIDTH)
    ) uut (
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .coutfin(coutfin)
    );

    // Generación de estímulos
    initial begin

        $dumpfile("SumaC2_Testbench.vcd");
        $dumpvars(5, uut);
        // Cambio de entradas después de un cierto tiempo
        #10;
        a = 8'h0A; // Ejemplo de entrada a
        b = 8'h05; // Ejemplo de entrada b
        ci = 1'b0; // Ejemplo de acarreo de entrada

        // Cambios adicionales de entradas para probar diferentes casos
        #10;
        a = 8'hFF;
        b = 8'h01;
        ci = 1'b1;

        // Otros cambios de entradas pueden ser añadidos aquí

        // Terminar la simulación después de un cierto tiempo
        #100;
        $finish;
    end

    // Monitoreo de salidas
    always @(posedge $time) begin
        $display("Time = %0t: a = %h, b = %h, ci = %b, s = %h, coutfin = %b", $time, a, b, ci, s, coutfin);
    end

endmodule
