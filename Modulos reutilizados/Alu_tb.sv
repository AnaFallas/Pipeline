module Alu_tb;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo de reloj en unidades de tiempo

    // Definición de señales
    logic [31:0] A, B;
    logic [3:0] ALU_Sel;
    logic [31:0] ALU_Out;
    logic coutfin, z;
    logic clk = 0;

    // Instancia del módulo Alu bajo prueba
    Alu uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .coutfin(coutfin),
        .z(z)
    );

    // Generación de estímulos
    initial begin
        // Inicialización de entradas
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        ALU_Sel = 4'b0000;

        // Generación del reloj
        forever begin
            #((CLK_PERIOD / 2)) clk = ~clk;
            #1; // Espera mínima para evitar el bloqueo del simulador
        end
    end

    // Cambio de entradas
    always @(posedge clk) begin
        // Cambiar las entradas después de ciertos periodos de tiempo
        #10 A = 32'hABCDEFFF;
        #10 B = 32'h12345678;
        #10 ALU_Sel = 4'b0010;
    end

    // Monitoreo de salidas
    always @(posedge clk) begin
        $display("A = %h, B = %h, ALU_Sel = %h, ALU_Out = %h, coutfin = %b, z = %b", A, B, ALU_Sel, ALU_Out, coutfin, z);
    end

endmodule
