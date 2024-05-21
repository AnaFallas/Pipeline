`timescale 1ns/1ns 
`include "ControlUnit.sv"
module Control_Unit_tb;

    // Definición de constantes para los códigos de operación
    parameter R_TYPE_OP = 7'b0110011;
    parameter LOAD_OP = 7'b0000011;
    parameter STORE_OP = 7'b0100011;
    parameter BRANCH_OP = 7'b1100011;
    parameter DEFAULT_OP = 7'b0000000;

    // Definición de señales de entrada
    logic [6:0] OpCode;
    
    // Definición de señales de salida
    logic Branch, MemRead, MemtoReg;
    logic [1:0] Aluop;
    logic MemWrite, AluSrc, RegWrite;

    // Instancia del módulo Control_Unit bajo prueba
    Control_Unit uut (
        .OpCode(OpCode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .Aluop(Aluop),
        .MemWrite(MemWrite),
        .AluSrc(AluSrc),
        .RegWrite(RegWrite)
    );

    // Generación de estímulos
    initial begin

        $dumpfile("ControlUnitTb.vcd");
        $dumpvars(5, uut);
        // Cambio de OpCode para probar diferentes combinaciones
        OpCode = R_TYPE_OP;
        #10;
        OpCode = LOAD_OP;
        #10;
        OpCode = STORE_OP;
        #10;
        OpCode = BRANCH_OP;
        #10;
        OpCode = DEFAULT_OP;
        #10;
        
        // Terminar simulación después de un cierto tiempo
        #100;
        $finish;
    end

    // Monitoreo de salidas
    always @(OpCode) begin
        $display("Time = %0t: OpCode = %b, Branch = %b, MemRead = %b, MemtoReg = %b, Aluop = %b, MemWrite = %b, AluSrc = %b, RegWrite = %b", $time, OpCode, Branch, MemRead, MemtoReg, Aluop, MemWrite, AluSrc, RegWrite);
    end

endmodule
