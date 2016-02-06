module test_cpu;

	reg  clk/*clock*/, n_rst/*reset?*/; 
	reg  hlt/*zHLT*/;
	reg  [31:0] mdr;
	
	wire [4:0] phase;
	wire [2:0] ra1/*read address1*/, ra2/*read address2*/, wba;
	wire [31:0] q, d_in, p_in, rd1/*read data1*/, rd2/*read date2*/, z/*answer*/, p, m_rdaddress, wb;
	wire [7:0] sim8;
	wire [9:0] ikind;
	wire [15:0] im16;
	wire ct_taken, r_we, m_we;
	
	// フェーズ信号
	phase_gen pg(hlt, phase, clk, n_rst);
	
	//pc
	pc pc(phase, ct_taken, p, wb, clk, n_rst);
	
	// レジスタ・ファイル
	register_file rf(phase, ra1, ra2, wba, rd1, rd2, wb, r_we, clk, n_rst);	

	//alu
	alu alu (rd1, rd2, ra1, sim8, im16, ikind, phase, clk, n_rst, z, ct_taken);
	
	//decorder
	decoder de(q, clk, phase, ra1, ra2, sim8, im16, ikind, r_we, m_we);
	
	//main memory
	ram2 ram2(clk, rd1, m_rdaddress[13:2], z[13:2], m_we, q);
	
	assign m_rdaddress = (phase[3]) ? z : p;
	assign wb = (ikind == 10'b10_0010_1101) ? q : z;
	assign wba = (ikind == 10'b10_0010_1101) ? ra1 : ra2;
	
	initial begin
		clk  = 0;  n_rst = 0;	
				
		#100  n_rst = 1;
		#1;

	end
 
	always begin	
		#5 clk = ~clk;
	end
	
endmodule