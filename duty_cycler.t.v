`include "duty_cycler.v"

module test_duty_cycler();

   reg clk;
   wire cycler_out;
   reg[1:0] duty_cycle;


   duty_cycler cycler (.clk(clk),
      .duty_cycle(duty_cycle),
      .out(cycler_out));

   initial
      clk <= 1'b0;

   always
      #4 clk <= ~clk;

   initial begin

      $dumpfile("duty_cycler.vcd");
      $dumpvars();

      duty_cycle = 2'd0;
      #300
      duty_cycle = 2'd1;
      #300
      duty_cycle = 2'd2;
      #300
      duty_cycle = 2'd3;
      #300

      $finish();     

   end












endmodule
