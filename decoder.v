module decoder (in, clk, phase, rg1, rg2, sim8, im16, ikind, r_we, m_we);
	input	[31:0] in;
	input	[4:0] phase;
	input clk;
	
	output  r_we, m_we;
	output [2:0] rg1, rg2;
   output [7:0] sim8;
   output [9:0] ikind;
	output [15:0] im16;
	
	wire	m_we;
	
	reg  decoder_m_we, r_we;
	reg [2:0] rg1, rg2;
   reg [7:0] sim8;
   reg [9:0] ikind;
	reg [15:0] im16;
	
	always @ (posedge clk) begin
		if(phase[1] == 1) begin
			casex (in[31:22]) 
				10'b1000_101x_01 : //ld
					begin
						ikind <= in[31:22];
						rg1 <= in[21:19];
						rg2 <= in[18:16];
						sim8 <= in[15:8];	
						r_we <= 1;
						decoder_m_we <= 0;
					end
				10'b1000_100x_01 : //st
					begin
						ikind <= in[31:22];
						rg1 <= in[21:19];
						rg2 <= in[18:16];
						sim8 <= in[15:8];
						r_we <= 0;
						decoder_m_we <= 1;
					end
				10'b1001_0000_11 :	//b 
					begin
						sim8 <= in[15:8];
						r_we <= 0;
						decoder_m_we <= 0;
					end
				10'b1111_1111_11 :	//jr 
					begin
						rg2 <= in[18:16];
						r_we <= 0;
						decoder_m_we <= 0;
					end
				10'b0110_0110_10: //lil
					begin
						ikind <= in[31:22];
						rg1 <= in[21:19];
						rg2 <= in[18:16];
						im16 <= {in[7:0],in[15:8]};
						r_we <= 1;
						decoder_m_we <= 0;
					end
				default : //default
					begin
						ikind <= in[31:22];
						rg1 <= in[21:19];
						rg2 <= in[18:16];
						sim8 <= in[15:8];
						r_we <= 1;
						decoder_m_we <= 0;
					end
			endcase
		end
	end
   assign m_we = (phase[3] == 1 && decoder_m_we == 1) ? 1 : 0;
endmodule	
