`include "timers.v"

module testTimer();

	reg clk;
	wire clkOut;

	// fixedTimer #(5) tmr(clk, clkOut);
	varTimer #(3) tmr(clk, 3'd5, clkOut);

	initial begin
		clk = 0;
		
		$monitor("clk=%b, clkOut=%b, i=", clk, clkOut, tmr.i);

		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;

		$finish;
	end
endmodule
