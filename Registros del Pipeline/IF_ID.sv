module IF_ID (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction_in
    input logic [63:0] pc
    output logic [63:0] out_pc
    output logic [31:0] instruction_out
    output logic en_sumador,
);

    // Declaramos el registro de pipeline
    logic [31:0] instruction_reg;

 
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_reg <= 32'h00000000;
        end else begin
            instruction_reg <= instruction_in;
        end
    end

    // Asignamos la salida del registro
    assign instruction_out = instruction_reg;

endmodule