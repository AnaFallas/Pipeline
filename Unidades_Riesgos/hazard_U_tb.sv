`timescale 1ns/1ns
`include "Hazard_U.sv"

module hazard_U_tb;

    // Parámetros de simulación
    localparam CLK_PERIOD = 10; // Período de reloj en unidades de tiempo

    // Señales de entrada
    logic [4:0] R_d;
    logic MemRead;
    logic [31:0] Instruction;

    // Señales de salidas
    logic SignalPC;

    // Instancia del módulo bajo prueba
    Hazard_U uut (
        .R_d(R_d),
        .MemRead(MemRead),
        .Instruction(Instruction),
        .SignalPC(SignalPC)
    );

    // Inicialización
    initial begin
        $dumpfile("Hazard_U.vcd");
        $dumpvars(5, uut);
        // Inicializar señales
        R_d = 5'b00000;
        MemRead = 0;
        Instruction = 32'h00000000;

        // Esperar un poco antes de cambiar los valores de entrada
        #20;

        // Cambiar los valores de entrada
        R_d = 5'b01010; // Ejemplo de una dirección de destino
        MemRead = 1;
        Instruction = 32'h8A620013; // Ejemplo de una instrucción con rs1 = 10 y rs2 = 9

        // Esperar un ciclo de reloj
        #CLK_PERIOD;

        // Mostrar resultados
        $display("SignalPC = %b", SignalPC);

        // Finalizar simulación
        $finish;
    end

endmodule
