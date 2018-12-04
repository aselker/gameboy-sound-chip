module volumizer(

   input clk,
   input envelope_add,
   input trigger,
   input[2:0] period,
   input[3:0] starting_volume,

   output reg[3:0] volume

);


   reg change_enable;


   initial begin
      change_enable <= 1'b0;
   end


   always @(posedge clk) begin

      if (trigger) begin
         volume <= starting_volume;
         change_enable <= 1'b1;

      end else if (period != 3'h0 && change_enable)
         
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
