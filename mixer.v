`include "swDac.v"

module mixer(
	input [3:0] enL, enR,
	input [2:0] volL, volR,
	input [3:0] sq1, sq2, wave, noise
);

	wire [8:0] left, right; // 9 bits is enouch (in real life this is analog)
	assign left = (volL + 1) * ( (enL[0] * noise) + (enL[1] * wave) + (enL[2] * sq2) + (enL[3] * sq1) );
	assign right = (volR + 1) * ( (enR[0] * noise) + (enR[1] * wave) + (enR[2] * sq2) + (enR[3] * sq1) );

	swDac #(9, 128) dac(left, right);

endmodule
