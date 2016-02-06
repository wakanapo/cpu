`define f 0
`define w 4

module pc(phase, ct_taken, pc, dr, clk, n_rst);
	input  [`w : `f]     	phase;   	// フェーズ信号.
	input                 	n_rst,ct_taken;	// 分岐成立．zB, zJR などでも 1
	input  [31:0]      	dr;
	output [31:0]      	pc;
	input                 	clk;    	// クロック と リセット
	
	reg [31:0] pc;
	
	always @(posedge clk or negedge n_rst) begin
		if (n_rst == 0) begin
		  pc <= 0; // 1箇所め
		end else begin
			if (phase[`f] == 1) begin
				pc <= pc + 4;
			end else if (phase[`w] == 1  &&  ct_taken == 1) begin
				pc <= dr; // 2箇所目
			end 
		end
	end // always
endmodule