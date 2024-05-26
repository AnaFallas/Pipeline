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
`include "SumaC2.sv"
//Archivos nuevos
`include "IF_ID.sv"
`include "ID_EX.sv"
`include "EX_MEM.sv"
`include "MEM_WB.sv"
`include "MEM_WB.sv"
`include "forwardunit.sv"
`include "Hazard_U.sv"


module Procesador_RISC;

    wire clk;
    reg pc_reset;
   //wire [63:0] oldpc;
    wire [63:0] newpc;//veremos
   // wire [31:0] instruction;
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
//Variables para registro IF/ID
    logic instruction_fetch[31:0];
    logic instruction_id[31:0];
    logic fetch_pc[63:0];
    logic id_pc[63:0];
//Variables para registro ID/EX
    logic reg_data_1_id[63:0];
    logic reg_data_2_id[63:0];
    logic output_sign_extend_id[63:0];

    logic reg_data_1_ex[63:0];
    logic reg_data_2_ex[63:0];
    logic output_sign_extend_ex[63:0];
    logic instruction_ex[31:0];

//Variables para registro EX/MEM
    logic output_alu_ex[63:0];
    logic output_alu_mem[63:0];
    logic instruction_mem[31:0];

//Variables para registro MEM/WB
    logic output_data_memory_mem[63:0];
    logic output_data_memory_wb[63:0];
    logic output_alu_wb[63:0];
    logic instruction_wb[31:0];
//Variables para Hazards



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
     fetch_pc
     );
   //Quite este adder porque es parte de la lógica del branch que no tenemos todavía 
   /* Adder adder1(
        oldpc,
        64'b100, 
        output_pc_adder
        );*/ 

    InstructionMemory InstructionMemory1(//LISTO
        .adr({2'b00,oldpc[63:2]}),
        .Instruction(instruction_fetch)
        //{2'b00,oldpc[63:2]}, 
        //instruction
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
        instruction_id[19:15], 
        instruction_id[24:20], 
        instruction_id[11:7], 

        input_data_register, //nuevo dato despues de un sw o lw
        clk, 
        reg_write, 
        reg_data_1_id, 
        reg_data_2_id
        );

     immgen GenImm(
        instruction,
        ImmGen,
        output_sign_extend_id
       // output_sign_extend
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
        output_alu_ex, 
        zero_alu
        );
   
    
    //logica del branch
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
        output_data_memory_mem
        );
    Multiplexor data_memory_multiplexor(
        output_alu, 
        output_data_memory, 
        mem_to_reg, 
        input_data_register
        );

    //Pipeline registros 
    IF_ID PipelineRegisto1(
        .clk(clk),
        .rst(pc_reset),
        .instruction_in(instruction_fetch),
        .pc(fetch_pc),
        .PCSrcD_Control(),//todavía no esta jsjs
        .flush(),//hazard tampoco está
        .instruction_out(instruction_id),
        .out_pc(id_pc)
    );
    ID_EX PipelineRegistro2(
        .clk(clk),
        .rst(),//pa despues
        .AluSrc_in(),//control
        .MemtoReg_in(),
        .RegWrite_in(),
        .MemRead_in(),
        .MemWrite_in(),
        .Aluop_in(),//control
        .rs1Data_in(reg_data_1_id),//registerbanck
        .rs2Data_in(reg_data_2_id),
        .rs_in(instruction_id[19:15]),
        .rt_in(instruction_id[24:20]),
        .rd_in(instruction_id[11:7]),
        .immediate_in(output_sign_extend_id),


        .AluSrc_out(),
        .MemtoReg_out(),
        .RegWrite_out(),
        .MemRead_out(),
        .MemWrite_out(),
        .Aluop_out(),
        .rs1Data_out(reg_data_1_ex),
        .rs2Data_out(reg_data_2_ex),
        .rs_out(instruction_ex[19:15]),
        .rt_out(instruction_ex[24:20]),
        .rd_out(instruction_ex[11:7]),
        .immediate_out(output_sign_extend_ex)
    );
    EX_MEM PipelineRegistro3(
        .clk(clk),
        .reset(),//pa despues

    // Señales de entrada, control
        .RegWrite(),
        .MemtoReg(),
        .MemWrite(),

    //Datos de entrada
        .AluResult(output_alu_ex),
        .Datain(),
        .Rd_in(instruction_ex[11:7]),

    // Señales de salida
        .RegWrite_Out(),
        .MemtoReg_Out(),
        .MemWrite_Out(),

    //datos de salida 
        .AluOut(output_alu_mem),
        .DataOut(),
        .Rd_out(instruction_mem[11:7])
    );

    MEM_WB PipelineRegistro4(
        .clk(clk),
        .reset(),//pa despues
    // Señales de entrada
        .RegWrite(),
        .MemtoReg(),

    //Datos de entrada
        .Dataout_Memory(output_data_memory_mem),
        .AluOut_in(output_alu_mem),
        .Rd_in(instruction_mem[11:7]),

    // Señales de salida
        .RegWrite_Out(),
        .MemtoReg_Out(),

    //datos de salida 
        .DataOut(output_data_memory_wb),
        .AluOut(output_alu_wb),
        .Rd_out(instruction_wb[11:7])
    );
    //Unidades de control de hazards
    forwardunit Unidad_de_adelantamiento(
        .Registro1(instruction_ex[19:15]),       
        .Registro2(instruction_ex[24:20]),       
        .Rd_execute(instruction_mem[11:7]),      
        .Rd_writeback(instruction_wb[11:7]),    
    
        .ex_regwrite(),//control           
        .wb_regwrite(),           
    
        .forwardA(),   //Seleccion de los mux     
        .forwardB()     
    );
    Hazard Unidad_de_Hazards(
        .R_d(),
        .MemRead(),
        .Instruction(), 
        
        .SignalPC()
    );

    initial begin
        $dumpfile("Procesador_RISC.vcd");
        $dumpvars(5, Procesador_RISC);
        repeat(20) @(posedge clk);
        $finish;
    end 

endmodule
