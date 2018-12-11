// `include "timers.v"

module swDac #(parameter width = 4, sample_time = 128 /*Default 32768 Hz*/) (
	input clk,
	input [width-1:0] left,
	input [width-1:0] right
);

	fixedTimer #(sample_time) timer(clk, sampleClk);

	initial $display("%d %d", width, sample_time); // begin with params so we can interpret the file

	always @(posedge sampleClk) begin
		$display("%d %d %d", 0 /*should be time*/, left, right);
	end

endmodule
