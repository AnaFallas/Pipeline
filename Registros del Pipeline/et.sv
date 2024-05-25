module registro_EX_MEM (
    input logic clk,         
    input logic rst,         
    input logic MemWrite_in,
    input logic MemtoReg_in,
    input logic RegWrite_in,
    input logic [63:0] ALU_Result_in,
    input logic [63:0] wr_data_in,
    input logic [4:0] dir_rd_in,
    output logic MemWrite_out,
    output logic MemtoReg_out,
    output logic RegWrite_out,
    output logic [63:0] ALU_Result_out,
    output logic [63:0] wr_data_out,
    output logic [4:0] dir_rd_out
);

    reg registro_MemWrite;
    reg registro_MemtoReg;
    reg registro_RegWrite;
    reg [63:0] registro_ALU_Result;
    reg [63:0] registro_wr_data;
    reg [4:0] registro_dir_rd;

    always_ff @(posedge clk) begin
        if (rst) begin 
            registro_MemWrite <= 1'b0;
            registro_MemtoReg <= 1'b0;
            registro_RegWrite <= 1'b0;
            registro_ALU_Result <= 64'b0;
            registro_wr_data <= 64'b0;
            registro_dir_rd <= 5'b0; 
        end else begin 
            registro_MemWrite <= MemWrite_in;
            registro_MemtoReg <= MemtoReg_in;
            registro_RegWrite <= RegWrite_in;
            registro_ALU_Result <= ALU_Result_in;
            registro_wr_data <= wr_data_in;
            registro_dir_rd <= dir_rd_in;
        end
    end
 
    assign MemWrite_out = registro_MemWrite;
    assign MemtoReg_out = registro_MemtoReg;
    assign RegWrite_out = registro_RegWrite;
    assign ALU_Result_out = registro_ALU_Result;
    assign wr_data_out = registro_wr_data;
    assign dir_rd_out = registro_dir_rd;

endmodule