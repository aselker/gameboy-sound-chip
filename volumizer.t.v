`include "volumizer.v"

module test_volumizer();

   reg clk;
   reg envelope_add;
   reg trigger;
   reg[2:0] period;
   reg[3:0] starting_volume;
   wire[3:0] volume;

   volumizer test_vol (.clk(clk),
      .envelope_add(envelope_add),
      .trigger(trigger),
      .period(period),
      .starting_volume(starting_volume),
      .volume(volume)
   );

   initial
      clk <= 0;
   
   always
      #4 clk <= ~clk;

   initial begin
      $dumpfile("volumizer.vcd");
      $dumpvars();

      envelope_add <= 1'b0;
      trigger <= 1'b0;
      period <= 3'b001;
      starting_volume <= 4'hf;
      
      #8;
      trigger <= 1'b1;
      #8;
      trigger <= 1'b0;

      #200
      envelope_add <= 1'b1;
      starting_volume <= 4'h8;
      #8
      trigger <= 1'b1;
      #8;
      trigger <= 1'b0;

      #200


      $finish();
   end

endmodule
