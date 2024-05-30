`timescale 1ns/1ns 
`include "RegisterBank.sv"
module RegisterBank_tb;

    // Parámetros
    parameter WIDTH = 5; // Ancho de los registros
    parameter SIM_TIME = 100; // Tiempo total de simulación

    // Definición de señales
    logic [WIDTH-1:0] register1, register2, register3;
    logic [63:0] datain;
    logic clk, regwrite;
    logic [63:0] dataout1, dataout2;

    // Instancia del módulo RegisterBank bajo prueba
    RegisterBank uut (
        .register1(register1),
        .register2(register2),
        .register3(register3),
        .datain(datain),
        .clk(clk),
        .regwrite(regwrite),
        .dataout1(dataout1),
        .dataout2(dataout2)
    );

    // Generación de estímulos
    initial begin
        // Inicialización de señales

        $dumpfile("RegisterBank.vcd");
        $dumpvars(0, uut);
        register1 = 5'b00000;
        register2 = 5'b00001;
        register3 = 5'b00010;
        datain = 64'h123456789ABCDEF0;
        clk = 1'b0;
        regwrite = 1'b0;

        // Cambio de señales después de cierto tiempo
        #10;
        clk = ~clk;
        regwrite = 1'b1;

        #10;
        clk = ~clk;
        regwrite = 1'b0;

        // Otros cambios de señales pueden ser añadidos aquí

        // Terminar simulación después de un cierto tiempo
        #SIM_TIME;
        $finish;
    end

    // Monitoreo de salidas
    always @(posedge clk) begin
        $display("Time = %0t: register1 = %h, register2 = %h, register3 = %h, datain = %h, regwrite = %b, dataout1 = %h, dataout2 = %h", $time, register1, register2, register3, datain, regwrite, dataout1, dataout2);
    end

endmodule
