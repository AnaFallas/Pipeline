module top_procesador_pipeline(
    input logic clk,
    input logic rst
);

//PC
logic [63:0] next_pc_int;
logic [63:0] pc_fetch;
logic [63:0] pc_id;

logic [63:0] pc_imm_int;
logic [63:0] pc_four_int;


logic [31:0] instr_fetch;
logic [31:0] instr_id;

logic RegWrite_id;
logic ALUSrc_id;
logic [1:0] ALUOp_id;
logic MemWrite_id;
logic MemtoReg_id;
logic MemRead_id;

logic RegWrite_ex;
logic ALUSrc_ex;
logic [1:0] ALUOp_ex;
logic MemWrite_ex;
logic MemtoReg_ex;
logic MemRead_ex;

logic RegWrite_m;
logic MemWrite_m;
logic MemtoReg_m;

logic RegWrite_wb;
logic MemtoReg_wb;

logic PCSrc_int;
logic [1:0] ImmType_int;

logic [63:0] rs1_int;
logic [63:0] rs2_int;

logic comparacion_int;

//Generador de immediatos
logic [63:0] imm_int;
logic [63:0] imm_shift_int;

logic stall_int;

logic [6:0] control_int;

logic [63:0] rs1_ex;
logic [63:0] rs2_ex;
logic [63:0] imm_ex;

logic [4:0] a_rs1_ex;
logic [4:0] a_rs2_ex;
logic [4:0] a_rd_ex;
logic [4:0] a_rd_mem;
logic [4:0] a_rd_wb;


//Resultados de la ALU
logic [63:0] alu_result_int;
logic zero_int;

//Muxes de Forward
logic [63:0] rs1_mux;
logic [63:0] rs2_mux;

logic [63:0] mux_ri_int;

logic [1:0] forward_a;
logic [1:0] forward_b;

logic [63:0] alu_result_mem;
logic [63:0] write_data_mem;

logic [63:0] read_data_mem;

logic [63:0] read_data_wb;
logic [63:0] alu_result_wb;

logic [63:0] write_data_reg;

// Instruction Fetch

mux_2_1 #(.W(64)) mux_mem_pc (
    .sel(and_int),
    .entrada_A(pc_four_int),
    .entrada_B(pc_imm_int),
    
    .salida_o(next_pc_int)
);

pc_four #(.W(64)) four_pc (
    .pc(pc_fetch),
    
    .result(pc_four_int)
);

program_counter pc(
    .clk(clk), .rst(rst), .en(stall_int),
    .next_pc(next_pc_int),
    
    .pc_o(pc_fetch)
);

inst_mem #(.W(32),.WA(64),.DEPTH(1024)) instr_memory (
    .address({2'b00,pc_fetch[63:2]}),
    .instr(instr_fetch)
);

registro_IF_ID register_IFID(
    .clk(clk),         
    .rst(rst),         
    .pc_in(pc_fetch),
    .instruction_in(instr_fetch),
    .we_control(stall_int),
    .IF_Flush(and_int),  
    .pc_out(pc_id),
    .instruction_out(instr_id)
);

// Instruction Decode

Unidad_Control uc(
    .opcode(instr_id[6:2]),
    .fnct1(instr_id[14:12]),
    .fnct2(instr_id[30]),
    
    .RegWrite(RegWrite_id),
    .ALUSrc(ALUSrc_id),
    .ALUOp(ALUOp_id),
    .MemWrite(MemWrite_id),
    .MemtoReg(MemtoReg_id),
    .PCSrc(PCSrc_int),
    .ImmType(ImmType_int),
    .MemRead(MemRead_id)
);

RegFile regf(
    .clk(~clk), 
    .WriteEn(RegWrite_wb),
    .rst(rst),
    .read1(instr_id[19:15]), 
    .read2(instr_id[24:20]), 
    .write_reg(a_rd_wb),
    .WD(write_data_reg),
    .RD1(rs1_int), 
    .RD2(rs2_int)
);

comparador comp(
    .data_rs1(rs1_int),
    .data_rs2(rs2_int),
    .comparacion(comparacion_int)
);

assign and_int = comparacion_int & PCSrc_int;

immgen gen_imm (
    .instr(instr_id),
    .ImmSrc(ImmType_int),
    .Out(imm_int)
);

Shift_left #(.n(64)) shifter (
    .dato(imm_int),
    .desplazado(imm_shift_int)
);

pc_imm #(.W(64)) imm_pc (
    .pc(pc_id),
    .imm(imm_shift_int),
    
    .result(pc_imm_int)
);

hazard_unit hazard
(
    .a_rd(a_rd_ex), 
    .MemRead(MemRead_ex),
    .instr(instr_id), 

    .stall_o(stall_int) 
);

mux_2_1 #(.W(7)) mux_stall(
    .sel(stall_int),
    .entrada_A({ALUOp_id,ALUSrc_id,MemRead_id,MemWrite_id,MemtoReg_id,RegWrite_id}),
    .entrada_B(7'b000_0000),
    
    .salida_o(control_int)
);

registro_ID_EX reg_id_ex(
    .clk(clk),         
    .rst(rst),         
    .ALUOP_in(control_int[6:5]),
    .ALUSrc_in(control_int[4]),
    .MemRead_in(control_int[3]),
    .MemWrite_in(control_int[2]),
    .MemtoReg_in(control_int[1]),
    .RegWrite_in(control_int[0]),

    .Data_rs1_in(rs1_int),
    .Data_rs2_in(rs2_int),

    .dir_rs1_in(instr_id[19:15]),
    .dir_rs2_in(instr_id[24:20]),

    .dir_rd_in(instr_id[11:7]),

    .imm_in(imm_int),

    .ALUOP_out(ALUOp_ex),
    .ALUSrc_out(ALUSrc_ex),
    .MemRead_out(MemRead_ex),
    .MemWrite_out(MemWrite_ex),
    .MemtoReg_out(MemtoReg_ex),
    .RegWrite_out(RegWrite_ex),

    .Data_rs1_out(rs1_ex),
    .Data_rs2_out(rs2_ex),

    .dir_rs1_out(a_rs1_ex),
    .dir_rs2_out(a_rs2_ex),
    .dir_rd_out(a_rd_ex),

    .imm_out(imm_ex)
);

mux_3_1 forward_A(
    .forward(forward_a),
    .entrada_A(rs1_ex),
    .entrada_B(alu_result_mem),
    .entrada_C(write_data_reg),
    .salida_o(rs1_mux)
);

mux_3_1 forward_B(
    .forward(forward_b),
    .entrada_A(rs2_ex),
    .entrada_B(alu_result_mem),
    .entrada_C(write_data_reg),
    .salida_o(rs2_mux)
);

mux_2_1 #(.W(64)) mux_imm_rs2 (
    .sel(ALUSrc_ex),
    .entrada_A(rs2_mux),
    .entrada_B(imm_ex),
    
    .salida_o(mux_ri_int)
);


ALU #(.n(64)) alu(
    .A(rs1_mux), .B(mux_ri_int),
    .ALUControl(ALUOp_ex),
    .Resultado(alu_result_int),
    .Cero(zero_int)
);

forward_unit unidad_forwarding(
    .id_ex_rs1(a_rs1_ex),
    .id_ex_rs2(a_rs2_ex),

    .ex_m_rd(a_rd_mem),        //EX/MEM
    .m_w_rd(a_rd_wb),         //MEM/WB

    .ex_m_reg_write(RegWrite_m), //EX/MEM
    .m_w_reg_write(RegWrite_wb), //MEM/WB

    .forward_a(forward_a),
    .forward_b(forward_b)
);

registro_EX_MEM ex_mem(
    .clk(clk),         
    .rst(rst),         
    .MemWrite_in(MemWrite_ex),
    .MemtoReg_in(MemtoReg_ex),
    .RegWrite_in(RegWrite_ex),

    .ALU_Result_in(alu_result_int),
    .wr_data_in(rs2_mux),
    .dir_rd_in(a_rd_ex),

    .MemWrite_out(MemWrite_m),
    .MemtoReg_out(MemtoReg_m),
    .RegWrite_out(RegWrite_m),

    .ALU_Result_out(alu_result_mem),
    .wr_data_out(write_data_mem),
    .dir_rd_out(a_rd_mem)
);

data_mem #(.W(64),.DEPTH(1024)) mem_data (
    .clk(clk),
    .write_enable(MemWrite_m),
    .rst(rst),
    .address(alu_result_mem), 
    .write_data(write_data_mem),
    
    .read_data(read_data_mem)
);

registro_MEM_WB mem_wb(
    .clk(clk),         
    .rst(rst),
    .MemtoReg_in(MemtoReg_m),
    .RegWrite_in(RegWrite_m),

    .Data_read_in(read_data_mem),
    .ALU_Result_in(alu_result_mem),
    .dir_rd_in(a_rd_mem),


    .MemtoReg_out(MemtoReg_wb),
    .RegWrite_out(RegWrite_wb),
    .Data_read_out(read_data_wb),
    .ALU_Result_out(alu_result_wb),
    .dir_rd_out(a_rd_wb)
);

mux_2_1 #(.W(64)) mux_mem_reg (
    .sel(MemtoReg_wb),
    .entrada_A(alu_result_wb),
    .entrada_B(read_data_wb),
    
    .salida_o(write_data_reg)
);


endmodule