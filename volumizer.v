module volumizer(

   input clk_64,
   input envelope_add,
   input trigger,
   input[2:0] period,
   input[3:0] starting_volume,

   output reg[3:0] volume

);


   reg[7:0] period_counter;
   reg change_enable;
   wire period_enable;

   assign period_enable = (period_counter == 8'b0);

   initial begin
      change_enable <= 1'b0;
      period_counter <= 8'b1;
   end

   always @(posedge clk_64) begin
      if (~trigger) begin
         if (period_counter < period - 8'b1)
            period_counter <= period_counter + 8'b1;
         else
            period_counter <= 8'b0;
      end
   end   

   always @(posedge trigger) begin
      volume <= starting_volume;
      change_enable <= 1'b1;
      period_counter <= (period > 8'b1);
   end

   always @(posedge clk_64) begin

      if (period != 3'h0 && change_enable && period_enable) begin
         
         // Increment volume up if enabled and add mode
         if (envelope_add) begin
            if (volume < 4'hf)
               volume <= volume + 4'h1;
            else
               change_enable <= 1'b0;

         // Decrement volume if enabled and subtract mode
         end else begin
            if (volume > 4'h0)
                volume <= volume - 4'h1;
            else
               change_enable <= 1'b0;
         end

      end

   end

endmodule
