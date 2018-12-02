`include "lenCounter.v"
`include "timers.v"

/*
NR41 FF20 --LL LLLL Length load (64-L)
NR42 FF21 VVVV APPP Starting volume, Envelope add mode, period
NR43 FF22 SSSS WDDD Clock shift, Width mode of LFSR, Divisor code
NR44 FF23 TL-- ---- Trigger, Length enable
*/

module noiseChannel(
	input clk,
	input lenClk,
	input [5:0] lenLoad, 
	input [3:0] startVol, 
	input envAdd, 
	input [2:0] envPeriod,
	input [3:0] clkShift, 
	input widthMode,
	input [2:0] divisor,
	input trigger, lenEnable,
	output noise
);
	
	wire chanEnable, srClk;
	wire [6:0] period;
	reg [14:0] sr;

	
	lenCounter lc(lenClk, lenLoad, trigger, lenEnable, chanEnable);

	assign period = clkShift == 0 ? 7'd8 : (16 * clkShift);
	varTimer #(7) tmr(clk, period, srClk);

	initial sr = 14'b0;
	always @(posedge srClk) sr <= widthMode ? {(sr[1]^sr[0]), sr[14:8], (sr[1]^sr[0]), sr[6:1]} : {(sr[1]^sr[0]), sr[13:1]};
	assign noise = chanEnable && !sr[0];

endmodule
