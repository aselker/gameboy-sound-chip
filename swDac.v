module swDac #(parameter width = 4, sample_time = 100) (
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

	always @(posedge clk) begin
		$display("%d %d %d", $time, left, right);
	end


	initial begin
		#1000;
		$finish;
	end

endmodule
