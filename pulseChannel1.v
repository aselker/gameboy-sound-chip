`include "pulseChannel2.v"

module pulseChannel1 (

   input clk,
   input clk_256, 
   input clk_128, 
   input clk_64,

   // Specific to Ch1 frequency sweep
   input[2:0] sweep_period,
   input negate,
   input[2:0] shift,

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

   reg sweep_enabled;
   reg[10:0] shadow;
   reg[2:0] period_counter;

   pulseChannel2 chan_2 (
      .clk(clk),
      .clk_256(clk_256),
      .clk_128(clk_128),
      .clk_64(clk_64),
      .freq(shadow),
      .length_load(length_load),
      .duty_cycle(duty_cycle),
      .starting_volume(starting_volume),
      .period(period),
      .length_enable(length_enable),
      .trigger(trigger),
      .env_add(env_add),
      .amplitude(amplitude)
   );

   wire[10:0] new_freq;
   wire[10:0] new_freq_nn;
   wire[10:0] new_freq_n;
   assign new_freq_nn = shadow + (shadow >> shift);
   assign new_freq_n = shadow - (shadow >> shift);
   assign new_freq = negate ? new_freq_n : new_freq_nn;

   // Setup
   initial begin
      sweep_enabled <= 1'b0;
      period_counter <= 3'b0;
      shadow <= 11'b0;
   end

   // Set shadow register to current frequency on trigger
   always @(posedge trigger) begin
      shadow <= freq;
      period_counter <= 3'b0;
      sweep_enabled <= ((sweep_period != 3'b0) || (shift != 3'b0));
   end

   always @(posedge clk_128) begin

      // increment period counter
      if ((period_counter < sweep_period - 3'b001) && (sweep_period > 3'b0))
         period_counter <= period_counter + 3'b001;
      else
         period_counter <= 3'b000;

      if (period_counter == 3'b0 && sweep_enabled) begin
         shadow <= new_freq;
      end

   end




endmodule
