`timescale 1ns/1ns
`include "Adder.sv"

module Adder_tb;

    // Parámetros y señales de entrada/salida
    logic [63:0] a;
    logic [63:0] b;
    logic [63:0] out;

    // Instanciar el módulo que se está probando
    Adder dut (
        .a(a),
        .b(b),
        .out(out)
    );

    // Estímulos de entrada
    initial begin

        $dumpfile("Adder.vcd");
        $dumpvars(5, dut);

        // Asignar valores a las entradas para la simulación
        a = 64'h1234567890ABCDEF;
        b = 64'hFEDCBA0987654321;

        // Esperar un tiempo para la estabilización
        #10;

        // Finalizar la simulación
        $finish;
    end

    // Monitorización de la salida
    always @(posedge $time) begin
        $display("out = %h", out);
    end

endmodule
