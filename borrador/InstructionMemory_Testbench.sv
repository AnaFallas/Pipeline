`include "Clock.sv"
`include "InstructionMemory.sv"
`timescale 1ns/1ns 
module InstructionMemory_Testbench;

    
    parameter CLOCK_PERIOD = 10;
    parameter MEM_SIZE = 16; 
    
    // Definición de señales
    logic [63:0] adr;
    logic [31:0] Instruction;

    // Instancia del módulo bajo prueba
    InstructionMemory #(MEM_SIZE) UUT (
        .adr(adr),
        .Instruction(Instruction)
    );

    // Generación de estímulos
    initial begin
        $dumpfile("InstructionMemory_Testbench.vcd");
        $dumpvars(5, UUT);
        
        // Realiza lecturas de instrucciones aleatorias
        repeat (50) begin
            adr = $random % MEM_SIZE; // Genera una dirección de memoria aleatoria
            #CLOCK_PERIOD; // Espera un ciclo de reloj
        end

        // Finaliza la simulación
        $finish;
    end

    // Simulación del reloj
    always #((CLOCK_PERIOD/2)) begin
        // Alternar el reloj cada periodo
    end

endmodule
