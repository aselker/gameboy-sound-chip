`include "mixer.v"

module testMixer();

	reg [3:0] enL, enR, sq1, sq2, wave, noise;
	reg [2:0] volL, volR;

	mixer dut(enL, enR, volL, volR, sq1, sq2, wave, noise);

	initial begin

		enL = 0; enR = 0;
		volL = 0; volR = 0;
		sq1 = 0; sq2 = 0; wave = 0; noise = 0;

		#257;

		sq1 = 4'd15; volL = 3'd7;
		enL = 4'b1000;
		#256;
	
		sq2 = 4'd15; wave = 4'd15; noise = 4'd15; 
		enL = 4'b1111;
		#256;
		$finish;
	end
endmodule
