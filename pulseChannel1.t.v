`include "pulseChannel1.v"

module test_pulse_1();

   reg clk;
   reg[21:0] clk_timer;

   wire clk_256, clk_128, clk_64;
   assign clk_64 = clk_timer[15];
   assign clk_128 = clk_timer[14];
   assign clk_256 = clk_timer[13];   

   reg length_enable, trigger, env_add;
   reg[10:0] freq;
   reg[5:0] length_load;
   reg[3:0] starting_volume;
   reg[2:0] period;
   reg[1:0] duty_cycle;

   reg[2:0] sweep_period;
   reg negate;
   reg[2:0] shift;

   wire[3:0] amplitude;

   pulseChannel1 test_pulse(

      clk, clk_256, clk_128, clk_64,
      sweep_period, negate, shift,
      freq, length_load, duty_cycle, starting_volume, period,
      length_enable, trigger, env_add,
      amplitude

   );

   initial begin
      clk <= 1'b0;
      clk_timer <= 22'b0;
      freq <= 11'b0;
      length_load <= 6'b0;
      starting_volume <= 4'b0;
      period <= 3'b0;
      duty_cycle <= 2'b0;
      trigger <= 1'b0;
      sweep_period <= 3'b000;
      negate <= 1'b0;
      shift <= 3'b0;

   end

   always
      #1 clk <= ~clk;

   always @(posedge clk) begin
      clk_timer = clk_timer + 22'b1;
      
   end

   initial begin
      $dumpfile("test_pulse_1.vcd");
      $dumpvars();

      #1000000;

      freq = 11'd1024;
      length_load = 6'b010010;
      starting_volume = 4'b1111;
      period = 3'b010;
      duty_cycle = 2'b01;
      length_enable = 1'b1;
      trigger = 1'b1;
      env_add = 1'b0;
      sweep_period = 3'b010;
      shift = 3'b011;


      #20;
      trigger = 1'b0;

      #1000000;      

      $finish();

   end

endmodule
