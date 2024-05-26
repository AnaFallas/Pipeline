module forwardunit(
 input logic [4:0] Registro1,       // Dirección del registro1 (ID/EX.rs1)
    input logic [4:0] Registro2,       // Dirección del registro2 (ID/EX.rs2)
    input logic [4:0] Rd_execute,      // Dirección del registro destino en la etapa EX/MEM (EX/MEM.rd)
    input logic [4:0] Rd_writeback,    // Dirección del registro destino en la etapa MEM/WB (MEM/WB.rd)
    
    input logic ex_regwrite,           // Señal de escritura de registro en la etapa EX/MEM
    input logic wb_regwrite,           // Señal de escritura de registro en la etapa MEM/WB
    
    output logic [1:0] forwardA,       // Señal de reenvío para el primer operando
    output logic [1:0] forwardB        // Señal de reenvío para el segundo operando
);


always_comb begin
    // Inicialización de las señales de reenvío
    forwardA = 2'b00; // No forwarding
    forwardB = 2'b00; // No forwarding

    // Verificación de reenvío para el primer operando (Registro1)
    if (ex_regwrite && (Rd_execute != 5'b0) && (Rd_execute == Registro1)) begin
        forwardA = 2'b10; // Forward desde EX/MEM
    end else if (wb_regwrite && (Rd_writeback != 5'b0) && (Rd_writeback == Registro1)) begin
        forwardA = 2'b01; // Forward desde MEM/WB
    end

    // Verificación de reenvío para el segundo operando (Registro2)
    if (ex_regwrite && (Rd_execute != 5'b0) && (Rd_execute == Registro2)) begin
        forwardB = 2'b10; // Forward desde EX/MEM
    end else if (wb_regwrite && (Rd_writeback != 5'b0) && (Rd_writeback == Registro2)) begin
        forwardB = 2'b01; // Forward desde MEM/WB
    end
end


endmodule