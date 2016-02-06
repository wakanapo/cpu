module  register_file(phase, ra1, ra2, wa, rd1, rd2, wd, we, clk, n_rst//, rf_out
);
	input  [ 2:0] ra1, ra2, wa;	// �A�h���X�i���W�X�^�ԍ��j
	output [31:0] rd1, rd2;    	// �ǂݏo���f�[�^
	input  [31:0] wd;         	// �������݃f�[�^
	input  we;
	input	 [4:0] phase;                  	// ���C�g�E�C�l�[�u��
	input  clk, n_rst;         	// �N���b�N�C���Z�b�g
     // output [255:0] rf_out;	// ���W�X�^�E�t�@�C���z���i�f�o�O�p�o�́j

 	integer i;

	reg [31:0] rf [0:7];        	// 32-bit x 8-word ���W�X�^�E�t�@�C���{��
	always @(posedge clk  or  negedge n_rst) begin
	   if (n_rst == 0) begin
	        for (i = 0; i < 8; i = i + 1)
	            rf[i] <= 0;
	   end else if (we == 1) begin
			if(phase[4] == 1) begin
	        rf[wa] <= wd;        	// ��������
			end
		end 
	end
	assign  rd1 = rf[ra1];  	// �ǂݏo��
	assign  rd2 = rf[ra2];  	// �ǂݏo��

	// assign rf_out = {rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]};	// �f�o�b�O�o��
endmodule