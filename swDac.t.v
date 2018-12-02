`include "swDac.v"

`define PERIOD 1000 // About 419 hz

module testSwDac();

	reg [3:0] left, right;
	reg [31:0] i;

	swDac dut(left, right);

	initial begin
		left = 0; right = 0;


		for (i = 0; i < 4194304; i += `PERIOD) begin
			left += 1;
			right += 1;
			#`PERIOD;
		end

		$finish;
	end

endmodule
