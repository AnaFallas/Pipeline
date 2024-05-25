module ShiftUnit #(parameter n = 64) (input_data, output_data);
    
    input logic [n - 1 : 0] input_data;
    output logic [n - 1 : 0] output_data;

    assign output_data = input_data << 1;
    
endmodule