`include "timers.v"
`include "lenCounter.v"

/*
NR30 FF1A E--- ---- DAC power
NR31 FF1B LLLL LLLL Length load (256-L)
NR32 FF1C -VV- ---- Volume code (00=0%, 01=100%, 10=50%, 11=25%)
NR33 FF1D FFFF FFFF Frequency LSB
NR34 FF1E TL-- -FFF Trigger, Length enable, Frequency MSB

       Wave Table
     FF30 0000 1111 Samples 0 and 1
     ....
     FF3F 0000 1111 Samples 30 and 31
*/

module waveChannel(
	input clk, clk256, enable, 
	input [1:0] vol,
	input [5:0] lenLoad, 
	input trigger, lenEnable,
	input [10:0] freq,
	input [31:0] [3:0] samples,
	output [3:0] signal
);

	
	reg [4:0] pos;
	initial pos = 0;
	
	varTimer #(12) posTimer(clk, {11'b0 - freq, 1'b0}, posClk);
	always @(posedge posClk) begin
		pos += 1; // It wraps around at 31 -> 0
		// $display("samples[%d] = %d", pos, samples[pos]);
	end
	
	lenCounter lc(clk256, lenLoad, trigger, lenEnable, chanEnable);

	assign signal = (enable == 0 || chanEnable == 0 || vol == 0) ? 0 : ( samples[pos] >> (vol-1) );

endmodule
