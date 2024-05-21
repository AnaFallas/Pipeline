`timescale 1ns/1ns 
`include "DataMemory.sv"

module Data_Memory_Testbench;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo de reloj en unidades de tiempo

    // Definición de señales
    logic [7:0] adr;
    logic [7:0] datain;
    logic w, r;
    logic clk = 0;
    logic [7:0] dataout;

    // Instancia del módulo DataMemory bajo prueba
    DataMemory uut (
        .adr(adr),
        .datain(datain),
        .w(w),
        .r(r),
        .clk(clk),
        .dataout(dataout)
    );

    // Generación de estímulos
    initial begin

        $dumpfile("Data_Memory_Testbench.vcd");
        $dumpvars(5,  uut);
        // Inicialización de entradas
        adr = 8'h00;
        datain = 8'hFF;
        w = 1'b1;
        r = 1'b0;

        // Ciclo de reloj
        forever #((CLK_PERIOD / 2)) clk = ~clk;
    end

    // Cambio de entradas
    always @(posedge clk) begin
        // Cambiar las entradas después de ciertos periodos de tiempo
        #20 adr = 8'h0A;
        #20 datain = 8'h55;
        #20 w = 1'b1;
        #20 r = 1'b1;
    end

    // Monitoreo de salidas
    always @(posedge clk) begin
        // Mostrar las salidas en cada ciclo de reloj
        $display("adr = %h, datain = %h, w = %b, r = %b, dataout = %h", adr, datain, w, r, dataout);
    end

endmodule
