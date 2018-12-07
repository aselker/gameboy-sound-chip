`include "duty_cycler.v"
`include "volumizer.v"
`include "timers.v"
`include "lenCounter.v"

module pulseChannel2(

   input clk,
   input clk_256,
   input clk_128,
   input clk_64,

   input[10:0] freq,
   input[5:0] length_load,
   input[1:0] duty_cycle,
   input[3:0] starting_volume,
   input[2:0] period,
   
   input length_enable,
   input trigger,
   input env_add,

   output[3:0] amplitude

);

   
   wire freq_clk;
   varTimer #(13) freq_timer_0 (.clk(clk),
      .period({11'b0 - freq, 2'b0}),
      .clkOut(freq_clk)
   );

   wire signal_phase_0,
      signal_phase_1;
   wire length_out;
   wire[3:0] volume_out;

   and length_and_cycler (signal_phase_1, signal_phase_0, length_out);

   duty_cycler cycler_0 (freq_clk, duty_cycle, signal_phase_0);

   lenCounter len_count_0 (clk_256, 
      length_load, 
      trigger, 
      length_enable, 
      length_out); 

   volumizer volume_0 (clk_64,
      env_add,
      trigger,
      period,
      starting_volume,
      volume_out);

   genvar i;
   generate
      for (i=0; i<4; i=i+1) begin
         and vol_out_and (amplitude[i], volume_out[i], signal_phase_1);
      end
   endgenerate

endmodule
