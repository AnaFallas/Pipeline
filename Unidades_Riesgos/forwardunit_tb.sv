`timescale 1ns/1ns
`include "forwardunit.sv"

module forwardunit_tb;

    // Definición de señales de entrada
    logic [4:0] Registro1;
    logic [4:0] Registro2;
    logic [4:0] Rd_execute;
    logic [4:0] Rd_writeback;
    logic ex_regwrite;
    logic wb_regwrite;
    
    // Definición de señales de salida
    logic [1:0] forwardA;
    logic [1:0] forwardB;

    // Instancia del módulo ForwardingUnit bajo prueba
    forwardunit uut (
        .Registro1(Registro1),
        .Registro2(Registro2),
        .Rd_execute(Rd_execute),
        .Rd_writeback(Rd_writeback),
        .ex_regwrite(ex_regwrite),
        .wb_regwrite(wb_regwrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // Generación de estímulos
    initial begin
        $dumpfile("forwardunit_tb.vcd");
        $dumpvars(0, forwardunit_tb);
        
        // Prueba 1: No hay reenvío
        ex_regwrite = 0;
        wb_regwrite = 0;
        Rd_execute = 5'b00001;
        Rd_writeback = 5'b00010;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Prueba 2: Reenvío desde EX/MEM para Registro1
        ex_regwrite = 1;
        wb_regwrite = 0;
        Rd_execute = 5'b00011;
        Rd_writeback = 5'b00010;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Prueba 3: Reenvío desde MEM/WB para Registro1
        ex_regwrite = 0;
        wb_regwrite = 1;
        Rd_execute = 5'b00001;
        Rd_writeback = 5'b00011;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Prueba 4: Reenvío desde EX/MEM para Registro2
        ex_regwrite = 1;
        wb_regwrite = 0;
        Rd_execute = 5'b00100;
        Rd_writeback = 5'b00011;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Prueba 5: Reenvío desde MEM/WB para Registro2
        ex_regwrite = 0;
        wb_regwrite = 1;
        Rd_execute = 5'b00001;
        Rd_writeback = 5'b00100;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Prueba 6: Reenvío para ambos registros
        ex_regwrite = 1;
        wb_regwrite = 1;
        Rd_execute = 5'b00100;
        Rd_writeback = 5'b00011;
        Registro1 = 5'b00011;
        Registro2 = 5'b00100;
        #10;

        // Terminar simulación después de un cierto tiempo
        #100;
        $finish;
    end

    // Monitoreo de salidas
    always @(*) begin
        $display("Time = %0t: Registro1 = %b, Registro2 = %b, Rd_execute = %b, Rd_writeback = %b, ex_regwrite = %b, wb_regwrite = %b, forwardA = %b, forwardB = %b", 
            $time, Registro1, Registro2, Rd_execute, Rd_writeback, ex_regwrite, wb_regwrite, forwardA, forwardB);
    end

endmodule
