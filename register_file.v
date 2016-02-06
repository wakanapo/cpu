module  register_file(phase, ra1, ra2, wa, rd1, rd2, wd, we, clk, n_rst//, rf_out
);
	input  [ 2:0] ra1, ra2, wa;	// アドレス（レジスタ番号）
	output [31:0] rd1, rd2;    	// 読み出しデータ
	input  [31:0] wd;         	// 書き込みデータ
	input  we;
	input	 [4:0] phase;                  	// ライト・イネーブル
	input  clk, n_rst;         	// クロック，リセット
     // output [255:0] rf_out;	// レジスタ・ファイル配線（デバグ用出力）

 	integer i;

	reg [31:0] rf [0:7];        	// 32-bit x 8-word レジスタ・ファイル本体
	always @(posedge clk  or  negedge n_rst) begin
	   if (n_rst == 0) begin
	        for (i = 0; i < 8; i = i + 1)
	            rf[i] <= 0;
	   end else if (we == 1) begin
			if(phase[4] == 1) begin
	        rf[wa] <= wd;        	// 書き込み
			end
		end 
	end
	assign  rd1 = rf[ra1];  	// 読み出し
	assign  rd2 = rf[ra2];  	// 読み出し

	// assign rf_out = {rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]};	// デバッグ出力
endmodule