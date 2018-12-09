`include "pulseChannel1.v"
`include "mixer.v"

`define PERIOD 4194304/16
`define LENGTH 1024
`define LONGREG reg [`LENGTH-1:0]

module gameboy();


	reg [31:0] [3:0] waveTable;

	// Square 1
	`LONGREG [2:0] sq1_swpPd;
	`LONGREG sq1_negate;
	`LONGREG [2:0] sq1_shift;
	`LONGREG [1:0] sq1_duty;
	`LONGREG [5:0] sq1_lenLoad;
	`LONGREG [3:0] sq1_startVol;
	`LONGREG sq1_envAdd;
	`LONGREG [2:0] sq1_period;
	`LONGREG [10:0] sq1_freq;
	`LONGREG sq1_trigger;
	`LONGREG sq1_lenEnable;

	wire clk; baseClk baseclk(clk);
	wire clk256; fixedTimer #(16384) tmr256(clk, clk256);
	wire clk128; fixedTimer #(2) tmr128(clk256, clk128);
	wire clk64; fixedTimer #(2) tmr64(clk128, clk64);

	wire clkT; fixedTimer #(`PERIOD) tmrT(clk, clkT);
	reg [$clog2(`LENGTH)-1:0] t;
	always @(posedge clkT) begin
		if (t < LENGTH-1) t += 1;
		else $finish;
	end

	pulseChannel1 pc1(clk, clk256, clk128, clk64, 

	initial begin

		reg [5:0] ii; // Fill in the wave table with a triangle wave
		for (ii = 0; ii < 16; ii++) samples[ii] = ii;
		for (ii = 15; ii < 32; ii++) samples[ii] = 32 - ii;

		// PYTHON GO HERE

		
	end

endmodule
