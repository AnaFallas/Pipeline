module pc (
    input logic clk,
    input logic rst,
    input logic en_hold,
    input logic [63:0] pc_sig,
    output logic [63:0] asig_pc
);
    always_ff @(posedge clk) begin
        if (rst)begin 
            asig_pc <= 64'b0;
        end else if (!en_hold) begin
            asig_pc <= pc_sig;
        end else begin
            asig_pc <= asig_pc;
        end
    end
endmodule
