module swDac #(parameter width = 4, sample_time = 128 /*Default 32768 Hz*/) (
	input [width-1:0] left,
	input [width-1:0] right
);

	reg clk;	
	initial begin
		clk = 1;
		forever begin
			#1 clk = 0;
			#(sample_time-1) clk = 1;
		end
	end

	initial $display("%d %d", width, sample_time); // begin with params so we can interpret the file

	always @(posedge clk) begin
		$display("%d %d %d", $time, left, right);
	end

endmodule
