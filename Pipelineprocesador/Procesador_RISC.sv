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
`include "Mux3.sv"
`include "comparador.sv"



module Procesador_RISC;
    wire clk;
    reg pc_reset;
    wire [63:0] newpc;//veremos
    wire reg_to_loc;
    //wire branch;
    wire [1:0] ImmGen;
    wire muxShift;
    wire [4:0] output_register_bank_multiplexor;
//Variables de control
    logic branch_id;
    logic RegWrite_id;
    logic MemtoReg_id;
    logic MemWrite_id;
    logig AluControl_id[2:0];
    logic AluSRC_id;
    logic MemRead_id;
//---------------------------------
    logic RegWrite_ex;
    logic MemtoReg_ex;
    logic MemWrite_ex;
    logic MemRead_ex;
    logig AluControl_ex[2:0];
    logic AluSRC_ex;
//---------------------------------
    logic RegWrite_mem;
    logic MemtoReg_mem;
    logic MemWrite_mem;
//---------------------------------
    logic RegWrite_wb;
    logic MemtoReg_wb;
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

    logic resultWb[63:0];//mux wb
    logic selec_forwardA[1:0];
    logic selec_forwardB[1:0];
    logic result_forwardA[63:0];
    logic result_forwardB[63:0];
    logic entrada_B_ALU[63:0];
    logic result_forwardB_mem[63:0];
    logic enable_stall;
    logic comparador_result;
//Hay que revisar porque hay señales que ya no se usan
    wire [63:0] output_pc_adder, output_data_memory, output_alu, reg_data_1, reg_data_2,output_alu_multiplexor, input_data_register, output_sign_extend, output_shift_unit, output_shift_unit_adder;

    initial begin
        pc_reset = 1;
        @(posedge clk);
        @(posedge clk); pc_reset <= 0;
    end

    Clock clock1(
        clk
        );
//Etapa del Instruction Fetch
    pc pc1(clk,
     pc_reset, 
     newpc, 
     fetch_pc
     );

    InstructionMemory InstructionMemory1(//LISTO
        .adr({2'b00,oldpc[63:2]}),
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
//Pueba

     immgen GenImm(//listo
        instruction_id,
        ImmGen,
        output_sign_extend_id
    );
   
//logica del branch
    comparador branch_comparador(//listo
        .dato_rs1(reg_data_1_id),
        .dato_rs2(reg_data_2_id),
        .resultado(comparador_result)
        );

    assing and_branch = comparador_result & branch_id;//listo

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
    //Quite este adder porque es parte de la lógica del branch que no tenemos todavía 
   /* Adder adder1(
        oldpc,
        64'b100, 
        output_pc_adder
        );*/ 

    /*Multiplexor shift_unit_multiplexor(//Utilizar para el branch 
        output_pc_adder, 
        output_shift_unit_adder, 
        muxShift, 
        newpc
        );*/
//fin logica branch 

//Etapa del execute 
    Alu alu1(
        .A(result_forwardA), 
        .B(entrada_B_ALU),
        .ALU_Sel(AluControl_ex),
        .ALU_Out(output_alu_ex),
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
        .r(),//VERO
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

    //Pipeline registros intermedios Listo
    IF_ID PipelineRegisto1(
        .clk(clk),
        .rst(pc_reset),
        .instruction_in(instruction_fetch),
        .pc(fetch_pc),
        .PCSrcD_Control(enable_stall),//todavía no esta jsjs
        .flush(),//hazard tampoco está
        .instruction_out(instruction_id),
        .out_pc(id_pc)
    );
    ID_EX PipelineRegistro2(
        .clk(clk),
        .rst(),//pa despues
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
        .reset(),//pa despues
    // Señales de entrada, control
        .RegWrite(RegWrite_ex),
        .MemtoReg(MemtoReg_ex),
        .MemWrite(MemWrite_ex),
    //Datos de entrada
        .AluResult(output_alu_ex),
        .Datain(result_forwardB),//MUX
        .Rd_in(instruction_ex[11:7]),
    // Señales de salida
        .RegWrite_Out(RegWrite_mem),
        .MemtoReg_Out(MemtoReg_mem),
        .MemWrite_Out(MemWrite_mem),
    //datos de salida 
        .AluOut(output_alu_mem),
        .DataOut(result_forwardB_mem),//mux
        .Rd_out(instruction_mem[11:7])
    );
    MEM_WB PipelineRegistro4(
        .clk(clk),
        .reset(),//pa despues
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
    Hazard Unidad_de_Hazards(//listo
        .R_d(instruction_ex[11:7]),
        .MemRead(MemRead_ex),
        .Instruction(instruction_id), 
        .SignalPC(enable_stall)//revisar el pc
    );
//Falta:copiar el reset, la unidad de branch  
    initial begin
        $dumpfile("Procesador_RISC.vcd");
        $dumpvars(5, Procesador_RISC);
        repeat(20) @(posedge clk);
        $finish;
    end 

endmodule
