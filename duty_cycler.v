module duty_cycler (
   input clk,
   input[1:0] duty_cycle,
   output reg out
);

   reg[7:0] dut_125, dut_250, dut_500, dut_750;

   initial begin
      dut_125 <= 8'b00000001;
      dut_250 <= 8'b10000001;
      dut_500 <= 8'b10000111;
      dut_750 <= 8'b01111110;
   end

   always @(posedge clk) begin

      // Shift each register by 1
      dut_125 <= {dut_125[6:0], dut_125[7]};
      dut_250 <= {dut_250[6:0], dut_250[7]};
      dut_500 <= {dut_500[6:0], dut_500[7]};
      dut_750 <= {dut_750[6:0], dut_750[7]};
      
      if (duty_cycle == 2'd0)
         out <= dut_125[7];
      else if (duty_cycle == 2'd1)
         out <= dut_250[7];
      else if (duty_cycle == 2'd2)
         out <= dut_500[7];
      else
         out <= dut_750[7];

   end
endmodule
