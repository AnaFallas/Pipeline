module ID_EX (
    input logic clk,
    input logic rst,
    
    input logic AluSrc_in,
    input logic MemtoReg_in,
    input logic RegWrite_in,
    input logic MemRead_in,
    input logic MemWrite_in,
    input logic Aluop_in,

    input logic [63:0] rs1Data_in,
    input logic [63:0] rs2Data_in,
    input logic [4:0] rs_in,
    input logic [4:0] rt_in,
    input logic [4:0] rd_in,
    input logic [63:0] immediate_in,
    
    output logic AluSrc_out,
    output logic MemtoReg_out,
    output logic RegWrite_out,
    output logic MemRead_out,
    output logic MemWrite_out,
    output logic Aluop_out,
    output logic [63:0] rs1Data_out,
    output logic [63:0] rs2Data_out,
    output logic [4:0] rs_out,
    output logic [4:0] rt_out,
    output logic [4:0] rd_out,
    output logic [63:0] immediate_out
);

    // Declaración de los registros del pipeline
    
    logic reg_AluSrc;
    logic reg_MemtoReg;
    logic reg_RegWrite;
    logic reg_MemRead;
    logic reg_MemWrite;
    logic reg_Aluop;
    logic [63:0] reg_rs1Data;
    logic [63:0] reg_rs2Data;
    logic [4:0] reg_rs;
    logic [4:0] reg_rt;
    logic [4:0] reg_rd;
    logic [63:0] reg_immediate;
    

    // Proceso para el registro de pipeline
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_AluSrc <= 1'b0;
            reg_MemtoReg <= 1'b0;
            reg_RegWrite <= 1'b0;
            reg_MemRead <= 1'b0;
            reg_MemWrite <= 1'b0;
            reg_Aluop <= 2'b00;
            reg_rs1Data <= 64'b0;
            reg_rs2Data <= 64'b0;
            reg_rs <= 5'b0;
            reg_rt <= 5'b0;
            reg_rd <= 5'b0;
            reg_immediate <= 64'b0;
        end else begin
            reg_AluSrc <= AluSrc_in;
            reg_MemtoReg <= MemtoReg_in;
            reg_RegWrite <= RegWrite_in;
            reg_MemRead <= MemRead_in;
            reg_MemWrite <= MemWrite_in;
            reg_Aluop <= Aluop_in;
            reg_rs1Data <= rs1Data_in;
            reg_rs2Data <= rs2Data_in;
            reg_rs <= rs_in;
            reg_rt <= rt_in;
            reg_rd <= rd_in;
            reg_immediate <= immediate_in;
        end
    end

    // Asignamos las salidas de los registros
    assign AluSrc_out = reg_AluSrc;
    assign MemtoReg_out = reg_MemtoReg  ;
    assign RegWrite_out = reg_RegWrite;
    assign MemRead_out = reg_MemRead;
    assign MemWrite_out = reg_MemWrite;
    assign Aluop_out = reg_Aluop;
    assign rs1Data_out = reg_rs1Data;
    assign rs2Data_out = reg_rs2Data;
    assign rs_out = reg_rs;
    assign rt_out = reg_rt;
    assign rd_out = reg_rd;
    assign immediate_out = reg_immediate;

endmodule
