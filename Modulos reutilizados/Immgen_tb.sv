`timescale 1ns/10ps
`include "immgen.sv"


module immgen_tb;

    // Parámetros y señales de entrada/salida
    reg [31:0] instr;
    reg [1:0] ImmSrc;
    wire [63:0] Out;

    // Instanciar el módulo que se está probando
    immgen dut (
        .instr(instr),
        .ImmSrc(ImmSrc),
        .Out(Out)
    );

    // Estímulos de entrada
    initial begin

        $dumpfile("immgen.vcd");
        $dumpvars(5, dut);

        // Asignar valores a las entradas para la simulación
        instr = 32'h12345678;
        ImmSrc = 2'b00; // Tipo I

        // Esperar un tiempo para la estabilización
        #10;

        // Cambiar los valores de entrada para probar diferentes casos
        // Se pueden agregar más casos de prueba según sea necesario

        // Tipo S
        ImmSrc = 2'b01;
        instr = 32'h87654321;
        #10;

        // Tipo B
        ImmSrc = 2'b10;
        instr = 32'hABCDEF01;
        #10;

        // Caso por defecto
        ImmSrc = 2'b11; // No se espera que esto suceda, pero se puede simular
        instr = 32'h00000000;
        #10;

        // Finalizar la simulación
        $finish;
    end

    // Monitorización de la salida
    always @(posedge $time) begin
        $display("Out = %h", Out);
    end

endmodule
