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

`include "forwardunit.sv"
`include "Hazard_U.sv"
`include "Mux3.sv"
`include "comparador.sv"



module Procesador_RISC;
    wire clk;
    reg pc_reset;
    wire [63:0] newpc;//Conexion del mux al pc 
    wire [1:0] ImmGen;
//Variables de control
    logic branch_id;
    logic RegWrite_id;
    logic MemtoReg_id;
    logic MemWrite_id;
    logic [2:0] AluControl_id;
    logic AluSRC_id;
    logic MemRead_id;
//---------------------------------
    logic RegWrite_ex;
    logic MemtoReg_ex;
    logic MemWrite_ex;
    logic MemRead_ex;
    logic [2:0] AluControl_ex;
    logic AluSRC_ex;
//---------------------------------
    logic RegWrite_mem;
    logic MemtoReg_mem;
    logic MemWrite_mem;
    logic MemRead_mem;
//---------------------------------
    logic RegWrite_wb;
    logic MemtoReg_wb;
//Variables para registro IF/ID
    logic [31:0] instruction_fetch;
    logic [31:0] instruction_id;
    logic [63:0] fetch_pc;
    logic [63:0] id_pc;
//Variables para registro ID/EX
    logic [63:0] reg_data_1_id;
    logic [63:0] reg_data_2_id;
    logic [63:0] output_sign_extend_id;

    logic [63:0] reg_data_1_ex;
    logic [63:0] reg_data_2_ex;
    logic [63:0] output_sign_extend_ex;
    logic [31:0] instruction_ex;
//Variables para registro EX/MEM
    logic [63:0] output_alu_ex;
    logic [63:0] output_alu_mem;
    logic [31:0] instruction_mem;

//Variables para registro MEM/WB
    logic output_data_memory_mem[63:0];
    logic output_data_memory_wb[63:0];
    logic output_alu_wb[63:0];
    logic instruction_wb[31:0];

    logic resultWb[63:0];//mux wb
//Variables para hazards 
    logic selec_forwardA[1:0];
    logic selec_forwardB[1:0];
    logic result_forwardA[63:0];
    logic result_forwardB[63:0];
    logic entrada_B_ALU[63:0];
    logic result_forwardB_mem[63:0];
    logic enable_stall;
    logic comparador_result;

    logic and_branch;


    wire [63:0] output_pc_adder, output_shift_unit, output_shift_unit_adder;

    initial begin
        pc_reset = 1;
        @(posedge clk);
        @(posedge clk); 
        pc_reset <= 0;
    end

    Clock clock1(
        clk
        );
//Etapa del Instruction Fetch
    pc pc1(
        .clk(clk),
        .rst(pc_reset),
        .en_hold(enable_stall),
        .pc_sig(newpc),

        .asig_pc(fetch_pc)
        
     );

    InstructionMemory InstructionMemory1(//LISTO
        .adr({2'b00,fetch_pc[63:2]}),
        .Instruction(instruction_fetch)
        );

    ControlUnit ControlUnit1(//Listo sin lo de los mux
        .OpCode(instruction_id[6:0]),
        .AluR(instruction_id[14:12]),

        .AluSrc(AluSRC_id),
        .MemtoReg(MemtoReg_id),
        .RegWrite(RegWrite_id),
        .MemRead(MemRead_id),
        .MemWrite(MemWrite_id),
        .Branch(branch_id),
        .Aluop(AluControl_id),
        .Imm(ImmGen)
         );
//Etapa del Instruction Decode 
    RegisterBank register_bank(//listo
        instruction_id[19:15], 
        instruction_id[24:20], 
        instruction_id[11:7], 

        resultWb, //nuevo dato despues de un sw o lw
        clk, 
        RegWrite_wb, 
        reg_data_1_id, 
        reg_data_2_id
        );

     immgen GenImm(//listo
        instruction_id,
        ImmGen,
        output_sign_extend_id
    );
   
//logica del branch + parte de la logica del pc
    comparador branch_comparador(//listo
        .dato_rs1(reg_data_1_id),
        .dato_rs2(reg_data_2_id),
        .resultado(comparador_result)
        );

    assign and_branch = comparador_result & branch_id;//listo

    ShiftUnit shift_unit(
        output_sign_extend_id, 
        output_shift_unit
        );

    Adder shift_unit_adder(
        id_pc, 
        output_shift_unit, 
        output_shift_unit_adder
        );
    //PC + 4 
    Adder adder1(
        .a(fetch_pc),
        .b(64'h4), 
        .out(output_pc_adder)
        );

    Multiplexor PC_counter(//Mux para el PC 
        output_pc_adder, 
        output_shift_unit_adder, 
        and_branch, 
        newpc
        );
//fin logica branch + parte de la logica del pc

//Etapa del execute 
    Alu alu1(
        .A(result_forwardA), 
        .B(entrada_B_ALU),
        .ALU_Sel(AluControl_ex),
        .ALU_Out(output_alu_ex)
        );
    
    Mux3 forwardA(  
        .a(reg_data_1_ex),
        .b(resultWb),    
        .c(output_alu_mem),
        .select(selec_forwardA),    
        .result(result_forwardA)
        );
     Mux3 forwardB(  
        .a(reg_data_2_ex),
        .b(resultWb),    
        .c(output_alu_mem),
        .select(selec_forwardB),    
        .result(result_forwardB)
        );
     Multiplexor alu_multiplexor(
        .a(result_forwardB),
        .b(output_sign_extend_ex),
        .select(AluSRC_ex),
        .result(entrada_B_ALU)
        );
//Etapa de MEM
    DataMemory data_memory(
        .adr(output_alu_mem),     
        .datain(result_forwardB_mem),  
        .w(MemWrite_mem),
        .r(MemRead_mem),
        .clk(clk),
        .dataout(output_data_memory_mem)
        );
//Mux de la etapa de WB
    Multiplexor data_memory_multiplexor(
        .a(output_data_memory_wb),
        .b(output_alu_wb),
        .select(MemtoReg_wb),
        .result(resultWb)
        );

//Pipeline registros intermedios
    IF_ID PipelineRegisto1(
        .clk(clk),
        .rst(pc_reset),
        .instruction_in(instruction_fetch),
        .pc(fetch_pc),
        .PCSrcD_Control(enable_stall),
        .flush(and_branch),//resultado del and para el branch
        .instruction_out(instruction_id),
        .out_pc(id_pc)
    );
    ID_EX PipelineRegistro2(
        .clk(clk),
        .rst(pc_reset),//pa despues
        .AluSrc_in(AluSRC_id),//control
        .MemtoReg_in(MemtoReg_id),
        .RegWrite_in(RegWrite_id),
        .MemRead_in(MemRead_id),
        .MemWrite_in(MemWrite_id),
        .Aluop_in(AluControl_id),//control
        .rs1Data_in(reg_data_1_id),//registerbanck
        .rs2Data_in(reg_data_2_id),
        .rs_in(instruction_id[19:15]),
        .rt_in(instruction_id[24:20]),
        .rd_in(instruction_id[11:7]),
        .immediate_in(output_sign_extend_id),


        .AluSrc_out(AluSRC_ex),
        .MemtoReg_out(MemtoReg_ex),
        .RegWrite_out(RegWrite_ex),
        .MemRead_out(MemRead_ex),
        .MemWrite_out(MemWrite_ex),
        .Aluop_out(AluControl_ex),
        .rs1Data_out(reg_data_1_ex),
        .rs2Data_out(reg_data_2_ex),
        .rs_out(instruction_ex[19:15]),
        .rt_out(instruction_ex[24:20]),
        .rd_out(instruction_ex[11:7]),
        .immediate_out(output_sign_extend_ex)
    );
    EX_MEM PipelineRegistro3(
        .clk(clk),
        .reset(pc_reset),//pa despues
    // Señales de entrada, control
        .RegWrite(RegWrite_ex),
        .MemtoReg(MemtoReg_ex),
        .MemWrite(MemWrite_ex),
        .MemRead(MemRead_ex),
    //Datos de entrada
        .AluResult(output_alu_ex),
        .Datain(result_forwardB),//MUX
        .Rd_in(instruction_ex[11:7]),
    // Señales de salida
        .RegWrite_Out(RegWrite_mem),
        .MemtoReg_Out(MemtoReg_mem),
        .MemWrite_Out(MemWrite_mem),
        .MemRead_out(MemRead_mem),
    //datos de salida 
        .AluOut(output_alu_mem),
        .DataOut(result_forwardB_mem),//mux
        .Rd_out(instruction_mem[11:7])
    );
    MEM_WB PipelineRegistro4(
        .clk(clk),
        .reset(pc_reset),//pa despues
    // Señales de entrada
        .RegWrite(RegWrite_mem),
        .MemtoReg(MemtoReg_mem),
    //Datos de entrada
        .Dataout_Memory(output_data_memory_mem),
        .AluOut_in(output_alu_mem),
        .Rd_in(instruction_mem[11:7]),
    // Señales de salida
        .RegWrite_Out(RegWrite_wb),
        .MemtoReg_Out(MemtoReg_wb),
    //datos de salida 
        .DataOut(output_data_memory_wb),
        .AluOut(output_alu_wb),
        .Rd_out(instruction_wb[11:7])
    );
    //Unidades de control de hazards
    forwardunit Unidad_de_adelantamiento(//listo
        .Registro1(instruction_ex[19:15]),       
        .Registro2(instruction_ex[24:20]),       
        .Rd_execute(instruction_mem[11:7]),      
        .Rd_writeback(instruction_wb[11:7]),    
    
        .ex_regwrite(RegWrite_ex),//control           
        .wb_regwrite(RegWrite_wb),           
    
        .forwardA(selec_forwardA),   //Seleccion de los mux     
        .forwardB(selec_forwardB)     
    );
    Hazard_U Unidad_de_Hazards(//listo
        .R_d(instruction_ex[11:7]),
        .MemRead(MemRead_ex),
        .Instruction(instruction_id), 
        .SignalPC(enable_stall)//revisar el pc
    );

    initial begin
        $dumpfile("Procesador_RISC.vcd");
        $dumpvars(5, Procesador_RISC);
        repeat(20) @(posedge clk);
        $finish;
    end 

endmodule