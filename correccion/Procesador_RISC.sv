`default_nettype none
`timescale 1ns/10ps
`include "Clock.sv"
`include "pc.sv"
`include "Adder.sv"
`include "InstructionMemory.sv"
`include "ControlUnit.sv"
`include "RegisterBank.sv"
`include "Alu.sv"
`include "ShiftUnit.sv"
`include "DataMemory.sv"
`include "Multiplexor.sv"

`include "immgen.sv"
//`include "AluControl.sv"
`include "SumaC2.sv"
module Procesador_RISC;

    wire clk;
    reg pc_reset;
    wire [63:0] oldpc;
    wire [63:0] newpc;
    wire [31:0] instruction;
    wire reg_to_loc;
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] Alu_Op;
    wire [1:0] ImmGen;
    wire mem_write;
    wire alu_src;
    wire reg_write;
    wire muxShift;
    wire [4:0] output_register_bank_multiplexor;

    wire zero_alu;

    //wire [1:0] alu_opcode;
    wire [63:0] output_pc_adder, output_data_memory, output_alu, reg_data_1, reg_data_2,output_alu_multiplexor, input_data_register, output_sign_extend, output_shift_unit, output_shift_unit_adder;

    initial begin
        pc_reset = 1;
        @(posedge clk);
        @(posedge clk); pc_reset <= 0;
    end

    Clock clock1(
        clk
        );

    pc pc1(clk,
     pc_reset, 
     newpc, 
     oldpc
     );

    Adder adder1(
        oldpc,
        64'b100, 
        output_pc_adder
        );

    InstructionMemory InstructionMemory1(
        {2'b00,oldpc[63:2]}, 
        instruction
        );
    ControlUnit ControlUnit1(
        instruction[6:0],
        instruction[14:12],

        alu_src,
        mem_to_reg,
        reg_write,
        mem_read,
        mem_write, 
        branch,

        Alu_Op, 
        ImmGen
         );

         

    RegisterBank register_bank(
        instruction[19:15], 
        instruction[24:20], 
        instruction[11:7], 
        input_data_register, 
        clk, 
        reg_write, 
        reg_data_1, 
        reg_data_2
        );
    Multiplexor alu_multiplexor(
        reg_data_2, 
        output_sign_extend, 
        alu_src, 
        output_alu_multiplexor
        );
    Alu alu1(
        reg_data_1, 
        output_alu_multiplexor, 
        Alu_Op,
        //alu_opcode, 
        output_alu, 
        zero_alu
        );
    immgen GenImm(
        instruction,
        ImmGen,
        output_sign_extend
    );
    
    ShiftUnit shift_unit(
        output_sign_extend, 
        output_shift_unit
        );
    Adder shift_unit_adder(
        oldpc, 
        output_shift_unit, 
        output_shift_unit_adder
        );

    assign muxShift =   zero_alu & branch;
    Multiplexor shift_unit_multiplexor(
        output_pc_adder, 
        output_shift_unit_adder, 
        muxShift, 
        newpc
        );
    DataMemory data_memory(
        output_alu, 
        reg_data_2, 
        mem_write, 
        mem_read, 
        clk, 
        output_data_memory
        );
    Multiplexor data_memory_multiplexor(
        output_alu, 
        output_data_memory, 
        mem_to_reg, 
        input_data_register
        );
   // AluControl alu_control_unit(
     //   Alu_Op, 
     //   instruction[31:21], 
     //   alu_opcode
      //  );

    initial begin
        $dumpfile("Procesador_RISC.vcd");
        $dumpvars(5, Procesador_RISC);
        repeat(20) @(posedge clk);
        $finish;
    end 

endmodule
