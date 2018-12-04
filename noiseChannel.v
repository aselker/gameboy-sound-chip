`include "lenCounter.v"
`include "timers.v"
`include "volumizer.v"

/*
NR41 FF20 --LL LLLL Length load (64-L)
NR42 FF21 VVVV APPP Starting volume, Envelope add mode, period
NR43 FF22 SSSS WDDD Clock shift, Width mode of LFSR, Divisor code
NR44 FF23 TL-- ---- Trigger, Length enable
*/

module noiseChannel(
	input clk, clk256, clk64,
	input [5:0] lenLoad, 
	input [3:0] startVol,
	input envAdd, 
	input [2:0] envPeriod,
	input [3:0] clkShift,  // What is this?
	input widthMode,
	input [2:0] divisor,
	input trigger, lenEnable,
	output [3:0] noise
);
	
	wire chanEnable, srClk;
	wire [6:0] period;
	reg [14:0] sr;

	
	lenCounter lc(clk256, lenLoad, trigger, lenEnable, chanEnable);

	assign period = divisor == 0 ? 7'd8 : (16 * divisor);
	varTimer #(7) tmr(clk, period, srClk);

	initial sr = 15'b1;
	always @(posedge srClk) begin
		sr <= widthMode ? {(sr[1]^sr[0]), sr[14:8], (sr[1]^sr[0]), sr[6:1]} : {(sr[1]^sr[0]), sr[14:1]};
	end

	wire [3:0] volume;
	volumizer vol(clk64, envAdd, trigger, envPeriod, startVol, volume);
	assign noise = (chanEnable && !sr[0]) ? volume : 0;

endmodule
