`include "AluControl.sv"
`timescale 1ns/1ns 
module AluControl_tb;

    // Parámetros
    parameter DELAY = 10; // Retardo entre cambios de entrada
    parameter SIM_TIME = 100; // Tiempo total de simulación

    // Definición de señales
    logic [1:0] ALUOp_in;
    logic [31:25] func7;
    logic [14:12] func3;
    logic [3:0] AluControl_out;

    // Instancia del módulo AluControl bajo prueba
    AluControl uut (
        .ALUOp_in(ALUOp_in),
        .func7(func7),
        .func3(func3),
        .AluControl_out(AluControl_out)
    );

    // Generación de estímulos
    initial begin

        $dumpfile("AluControlTb.vcd");
        $dumpvars(5, uut);
        // Inicialización de entradas
        ALUOp_in = 2'b00;
        func7 = 7'bxxxxxxx;
        func3 = 3'bxxx;

        // Cambio de entradas después de cierto tiempo
        #DELAY;
        ALUOp_in = 2'b10;
        func7 = 7'b0000000;
        func3 = 3'b000;

        #DELAY;
        ALUOp_in = 2'b10;
        func7 = 7'b0000000;
        func3 = 3'b111;

        #DELAY;
        ALUOp_in = 2'b10;
        func7 = 7'b0000000;
        func3 = 3'b110;

        #DELAY;
        // Otros cambios de entradas pueden ser añadidos aquí

        // Terminar simulación después de un tiempo específico
        #SIM_TIME;
        $finish;
    end

    // Monitoreo de salidas
    always @(posedge $time) begin
        $display("Time = %0t: ALUOp_in = %b, func7 = %b, func3 = %b, AluControl_out = %b", $time, ALUOp_in, func7, func3, AluControl_out);
    end

endmodule
