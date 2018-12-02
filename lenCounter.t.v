`include "lenCounter.v"

module testlenCounter();

	reg clk, trigger, lenEnable;
	reg [5:0] lenLoad;
	wire chanEnable;

	lenCounter dut(clk, lenLoad, trigger, lenEnable, chanEnable);

	initial begin
		$monitor("clk=%d  lenLoad=%d trigger=%b lenEnable=%b chanEnable=%b", clk, lenLoad, trigger, lenEnable, chanEnable);

		clk = 0; lenLoad = 6'd63; trigger = 0; lenEnable = 1;
		#10
		clk = 1; #10; clk = 0; #10;
		lenLoad = 6'd61; trigger = 1;
		clk = 1; #10; clk = 0; #10;
		trigger = 0;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;

		$finish;
	end
endmodule
