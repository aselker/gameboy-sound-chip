`include "lengthCounter.v"

module testLengthCounter();

	reg clk, trigger, lengthEnable;
	reg [5:0] lengthLoad;
	wire chanEnable;

	lengthCounter dut(clk, lengthLoad, trigger, lengthEnable, chanEnable);

	initial begin
		$monitor("clk=%d  lengthLoad=%d trigger=%b lengthEnable=%b chanEnable=%b", clk, lengthLoad, trigger, lengthEnable, chanEnable);

		clk = 0; lengthLoad = 6'd63; trigger = 0; lengthEnable = 1;
		#10
		clk = 1; #10; clk = 0; #10;
		lengthLoad = 6'd61; trigger = 1;
		clk = 1; #10; clk = 0; #10;
		trigger = 0;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;
		clk = 1; #10; clk = 0; #10;

		$finish;
	end
endmodule
