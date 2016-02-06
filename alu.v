module alu (a, b, ia, sim8, im16, ikind, phase, CLK, N_RST, z, ct_taken);
	input [31:0] a,b;
	input [15:0] im16;
	input [9:0] ikind;
	input [7:0] sim8;
	input [4:0] phase;
	input [2:0] ia;
	input CLK, N_RST;
	
	output ct_taken;
	output [31:0] z;
	
	reg ct_taken;
	reg [31:0] z;
	
	
		 always @(posedge CLK or negedge N_RST) begin
			if(N_RST == 0) begin
				z<=0;
				ct_taken <= 0;
			end else begin
				if(phase[2] == 1) begin
				casex(ikind)
					10'b1001_0000_11: 
							ct_taken <= 1;	//b
					10'b1111_1111_11: 	//jr
						begin
							ct_taken <= 1;
							z <= b;
						end
					10'b1000_101x_01:
						begin
							ct_taken <= 0;
							z <= b+sim8; //ld
						end
					10'b1000_100x_01:
						begin
							ct_taken <=0 ;
							z <= b+sim8;
						end	//st
				   10'b0110_0110_10: 
						begin
							ct_taken <= 0;
							z <= im16;	//lil
						end
					10'b1000_100x_11: 
						begin
							ct_taken <= 0;
							z <= a;
						end
					10'b0000_000x_11: 
						begin
							ct_taken <= 0;
							z <= a+b;	//add
						end
					10'b0010_100x_11: 
						begin
							ct_taken <= 0;
							z <= a-b;	//sub
						end
					10'b0010_000x_11: 
						begin
							ct_taken <= 0;
							z <= a&&b;	//and
						end
					10'b0000_100x_11: 
						begin
							ct_taken <= 0;
							z <= a||b;	//or
						end
					10'b1111_011x_11: 
						begin
							ct_taken <= 0;
							z <= !b;		//not
						end
					10'b1000_00xx_11:	//register --immediate
						begin
							ct_taken <= 0;
							case(ia)
								3'b000: z <= sim8+b;	//addi
								3'b101: z <= sim8-b;	//subi
								3'b100: z <= sim8&&b;	//andi
								3'b001: z <= sim8||b;	//ori
							endcase
						end
					default: 
						begin
							ct_taken <= 0;
							z <= 0;
						end
				endcase
			end
		end
	end
endmodule