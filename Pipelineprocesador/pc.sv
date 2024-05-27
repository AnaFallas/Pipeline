module pc (
    input logic clk,
    input logic rst,
    input logic en_hold,
    input logic [63:0] pc_sig,
    output logic [63:0] newpc
);
    always_ff @(posedge clk) begin
        if (rst)begin 
            newpc <= 0;
        end else if (!en_hold) begin
            newpc <= pc_sig;
        end else begin
            newpc <= newpc;
        end
    end
endmodule
