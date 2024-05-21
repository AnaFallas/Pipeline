`timescale 1ns/1ns 
`include "ShiftUnit.sv"
module ShiftUnit_Tb;

    // Parámetros
    parameter n = 64;  // Tamaño predeterminado

    // Señales
    logic [n-1:0] input_data;
    logic [n-1:0] output_data;

    // Instancia del módulo ShiftUnit
    ShiftUnit#(n) dut (
        .input_data(input_data),
        .output_data(output_data)
    );

    // Inicialización de la simulación
    initial begin

        $dumpfile("ShiftUnitTb.vcd");
        $dumpvars(5, dut);
        // Asignar valores de entrada
        input_data = 64'hABCDEFFF;  // Por ejemplo, un valor hexadecimal

        // Mostrar mensaje de inicio
        $display("Testbench para ShiftUnit");

        // Mostrar valores iniciales
        $display("Entrada input_data: %h", input_data);

        // Esperar un tiempo pequeño
        #10;

        // Mostrar resultado después del desplazamiento
        $display("Salida output_data después de desplazamiento:");
        $display("%h", output_data);

        // Verificar el resultado esperado
        if (output_data == (input_data << 1)) begin
            $display("Prueba exitosa: output_data es igual a input_data << 1");
        end else begin
            $display("Prueba fallida: output_data no coincide con input_data << 1");
        end

        // Finalizar simulación
        $finish;
    end

endmodule
