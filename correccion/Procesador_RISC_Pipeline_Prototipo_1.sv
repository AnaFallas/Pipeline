
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

module Procesador_RISC_Pipeline_Prototipo_1;

    wire clk;
    reg pc_reset;
    wire [63:0] oldpc, newpc;
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
    wire [63:0] output_pc_adder, output_data_memory, output_alu, reg_data_1, reg_data_2, output_alu_multiplexor, input_data_register, output_sign_extend, output_shift_unit, output_shift_unit_adder;

    // Definición del módulo Clock
    Clock clock1(
        .CLK(clk)
    );

    // Etapa Fetch (Buscar)
    pc pc1(
        .clk(clk),
        .rst(pc_reset),
        .oldpc(oldpc),
        .newpc(newpc)
    );

    Adder adder1(
        .A(oldpc),
        .B(64'b100),
        .sum(output_pc_adder)
    );

    InstructionMemory InstructionMemory1(
        .adr(newpc),
        .Instruction(instruction)
    );

    // Registro de pipeline entre Fetch y Decode
    IF_ID IF_ID_Reg(
        .clk(clk),
        .rst(pc_reset),
        .instruction_in(instruction),
        .pc(newpc),
        .PCSrcD_Control(muxShift),
        .instruction_out(instruction),
        .out_pc(oldpc)
    );

    // Etapa Decode (Decodificar)
    ControlUnit ControlUnit1(
        .OpCode(instruction[6:0]),
        .AluR(instruction[14:12]),
        .AluSrc(alu_src),
        .MemtoReg(mem_to_reg),
        .RegWrite(reg_write),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .Branch(branch),
        .Aluop(Alu_Op),
        .Imm(ImmGen)
    );

    immgen GenImm(
        .instr(instruction),
        .ImmSrc(instruction[14:12]),
        .Out(output_sign_extend)
    );

    RegisterBank register_bank(
        .register1(instruction[19:15]),
        .register2(instruction[24:20]),
        .register3(instruction[11:7]),
        .datain(input_data_register),
        .clk(clk),
        .regwrite(reg_write),
        .dataout1(reg_data_1),
        .dataout2(reg_data_2)
    );

    Multiplexor alu_multiplexor(
        .a(reg_data_2),
        .b(output_sign_extend),
        .select(alu_src),
        .result(output_alu_multiplexor)
    );

    Alu alu1(
        .A(reg_data_1),
        .B(output_alu_multiplexor),
        .ALU_Sel(Alu_Op),
        .ALU_Out(output_alu),
        .coutfin(zero_alu)
    );

    ShiftUnit shift_unit(
        .input_data(output_sign_extend),
        .output_data(output_shift_unit)
    );

    Adder shift_unit_adder(
        .A(oldpc),
        .B(output_shift_unit),
        .sum(output_shift_unit_adder)
    );

    // Registro de pipeline entre Decode y Execute
    ID_EX ID_EX_Reg(
        .clk(clk),
        .rst(pc_reset),
        .AluSrc_in(alu_src),
        .MemtoReg_in(mem_to_reg),
        .RegWrite_in(reg_write),
        .MemRead_in(mem_read),
        .MemWrite_in(mem_write),
        .Aluop_in(Alu_Op),
        .rs1Data_in(reg_data_1),
        .rs2Data_in(reg_data_2),
        .rs_in(instruction[19:15]),
        .rt_in(instruction[24:20]),
        .rd_in(instruction[11:7]),
        .immediate_in(output_sign_extend),
        .AluSrc_out(alu_src),
        .MemtoReg_out(mem_to_reg),
        .RegWrite_out(reg_write),
        .MemRead_out(mem_read),
        .MemWrite_out(mem_write),
        .Aluop_out(Alu_Op),
        .rs1Data_out(reg_data_1),
        .rs2Data_out(reg_data_2),
        .rs_out(instruction[19:15]),
        .rt_out(instruction[24:20]),
        .rd_out(instruction[11:7]),
        .immediate_out(output_sign_extend)
    );

    // Etapa Memory (Memoria)
    DataMemory data_memory(
        .adr(output_alu),
        .datain(reg_data_2), 
        .w(mem_write),
        .r(mem_read),
        .clk(clk),
        .dataout(output_data_memory)
    );

    // Registro de pipeline entre Execute y Memory
    EX_MEM EX_MEM_Reg(
        .clk(clk),
        .reset(pc_reset),
        .RegWrite(ID_EX_Reg.RegWrite_out),
        .MemtoReg(ID_EX_Reg.MemtoReg_out),
        .MemWrite(ID_EX_Reg.MemWrite_out),
        .AluResult(ID_EX_Reg.AluOut),
        .Datain(ID_EX_Reg.rs2Data_out),
        .Rd_in(ID_EX_Reg.rd_out),
        .RegWrite_Out(output_register_bank_multiplexor),
        .MemtoReg_Out(mem_to_reg),
        .MemWrite_Out(mem_write),
        .AluOut(output_alu),
        .DataOut(output_data_memory),
        .Rd_out(ID_EX_Reg.rd_out)
    );

    // Registro de pipeline entre Memory y WriteBack
    MEM_WB MEM_WB_Reg(
        .clk(clk),
        .reset(pc_reset),
        .RegWrite(EX_MEM_Reg.RegWrite_Out),
        .MemtoReg(EX_MEM_Reg.MemtoReg_Out),
        .Dataout_Memory(EX_MEM_Reg.DataOut),
        .AluOut_in(EX_MEM_Reg.AluOut),
        .Rd_in(EX_MEM_Reg.Rd_out),
        .RegWrite_Out(output_register_bank_multiplexor),
        .MemtoReg_Out(mem_to_reg),
        .DataOut(output_data_memory),
        .AluOut(output_alu),
        .Rd_out(EX_MEM_Reg.Rd_out)
    );

    // Registro de pipeline entre WriteBack y el banco de registros
    register_bank RegisterBank_Reg(
        .register1(output_register_bank_multiplexor),
        .register2(InstructionMemory1.rt),
        .register3(InstructionMemory1.rd),
        .datain(output_data_memory),
        .clk(clk),
        .regwrite(EX_MEM_Reg.RegWrite_Out),
        .dataout1(reg_data_1),
        .dataout2(reg_data_2)
    );

    // Lógica de control para detectar peligros de datos
    Hazard_U Hazard_Unit(
        .R_d(EX_MEM_Reg.Rd_out),
        .MemRead(EX_MEM_Reg.MemRead_out),
        .Instruction(instruction),
        .SignalPC(muxShift)
    );

    // Módulo de selección de dirección de salto
    Multiplexor jump_address_mux(
        .a(output_pc_adder),
        .b(EX_MEM_Reg.AluOut),
        .select(branch),
        .result(newpc)
    );

    // Módulo de reenvío de datos
    ForwardingUnit forwarding_unit(
        .Registro1(ID_EX_Reg.rs_out),
        .Registro2(ID_EX_Reg.rt_out),
        .Rd_execute(EX_MEM_Reg.Rd_out),
        .Rd_writeback(MEM_WB_Reg.Rd_out),
        .ex_regwrite(ID_EX_Reg.RegWrite_out),
        .wb_regwrite(EX_MEM_Reg.RegWrite_Out),
        .forwardA(muxShift[1:0]),
        .forwardB(muxShift[3:2])
    );

    initial begin
        pc_reset = 1;
        @(posedge clk);
        @(posedge clk); pc_reset <= 0;
    end

    initial begin
        $dumpfile("Procesador_RISC_Pipeline.vcd");
        $dumpvars(5, Procesador_RISC_Pipeline);
        repeat(20) @(posedge clk);
        $finish;
    end 

endmodule
