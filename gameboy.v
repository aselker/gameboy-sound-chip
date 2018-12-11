`include "pulseChannel1.v"
`include "swDac.v"

`define PERIOD 4194304/16
`define LENGTH 10'd1023
`define PLAYBACK_LENGTH 10'd187
`define LONGREG reg [`LENGTH:0]

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
		trigger = sq1_trigger[t];
		if (t < `PLAYBACK_LENGTH) t += 1;
		else $finish;
	end

	wire [3:0] sq1_out;
	reg [10:0] freq;
	reg trigger;
	always @(posedge clkT) begin
		freq = sq1_freq[t];
		// $display("freq is now %d", freq);
	end
	pulseChannel1 pc1(clk, clk256, clk128, clk64, sq1_swpPd[t], sq1_negate[t], sq1_shift[t], freq, sq1_lenLoad[t], sq1_duty[t], sq1_startVol[t], sq1_period[t], sq1_lenEnable[t], trigger, sq1_envAdd[t], sq1_out);

	reg [4:0] ii; // Fill in the wave table with a triangle wave

	// Clock at falling edge so that nothing else is going on at the same time
	swDac dac(!clk, sq1_out, sq1_out);

	initial begin
		t = 0;

		for (ii = 0; ii < 16; ii++) waveTable[ii] = {ii[3:0]};
		for (ii = 0; ii < 16; ii++) waveTable[ii+5'd16] = 4'd0 - {ii[3:0]};

		// PYTHON GO HERE
	
		freq = sq1_freq[0];
		trigger = sq1_trigger[0];
		
	end

endmodule
