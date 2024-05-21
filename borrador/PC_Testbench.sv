`include "pc.sv"
`timescale 1ns/1ns 
module PC_Testbench;
    parameter CLOCK_PERIOD = 10; 
    logic clk;
    logic rst;
    logic [31:0] oldpc;
    logic [31:0] newpc;
   
    pc UUT (
        .clk(clk),
        .rst(rst),
        .oldpc(oldpc),
        .newpc(newpc)
    );

    initial begin
         $dumpfile("PC_Testbench.vcd");
        $dumpvars(5, UUT);
  
        clk = 0;
        rst = 1;
        oldpc = 32'h00000000;

    
        #CLOCK_PERIOD;


        rst = 0;
        #CLOCK_PERIOD;

 
        repeat (10) begin
 
            clk = 1;
            #CLOCK_PERIOD;
            clk = 0;
            #CLOCK_PERIOD;

      
            oldpc = oldpc + 4;
        end
        $finish;
    end

    always #((CLOCK_PERIOD/2)) begin

        clk = ~clk;
    end

endmodule
