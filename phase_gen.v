`define ph_f 0
`define ph_r 1
`define ph_x 2
`define ph_m 3
`define ph_w 4

module phase_gen(hlt, phase, clk, n_rst);
	input  hlt;
	output [`ph_w : `ph_f] phase;
	input	 clk, n_rst;

	reg [2:0] n_rst_d;
	always @(posedge clk) begin	// ������
		n_rst_d <= {n_rst_d[1:0], n_rst};
	end

	reg [`ph_w : `ph_f] phase;
	always @(posedge clk  or negedge n_rst) begin
		if (n_rst == 0)           		// �񓯊����Z�b�g 
			phase <= 0;
		else if (hlt == 1)        		// zHLT ���߂ɂ�铯�����Z�b�g
			phase <= 0;
		else if (n_rst_d[2:1] ==  2'b01)	// �J�E���g�J�n
			phase <= 1;
		else
			phase <= {phase[3:0], phase[4]};
	end
endmodule