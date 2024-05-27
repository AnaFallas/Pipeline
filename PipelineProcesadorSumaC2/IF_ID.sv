module IF_ID (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_in,
    input logic [63:0] pc,
    input logic PCSrcD_Control,
    input logic flush,
    output logic [31:0] instruction_out,
    output logic [63:0] out_pc
    );

    // Declaramos el registro de pipeline
    logic [31:0] instruction_reg;
    logic [63:0] pc_reg;

 
    always_ff @(posedge clk ) begin
        if (rst | flush) begin
            instruction_reg <= 32'b0;
            pc_reg <= 64'b0;

        end else if(!PCSrcD_Control) begin
            instruction_reg <= instruction_in;
            pc_reg <= pc;

        end else begin
            pc_reg <= pc;
            instruction_reg <= instruction_reg;
        end
    end

    // Asignamos la salida del registro
    assign instruction_out = instruction_reg;
    assign out_pc = pc_reg;

endmodule