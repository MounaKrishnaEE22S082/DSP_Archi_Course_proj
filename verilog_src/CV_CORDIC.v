`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:39:17 04/08/2023 
// Design Name: 
// Module Name:    CV_CORDIC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CV_CORDIC(
//parameter width = 16;
   input clk,
   input rst,
	 input start,
	 input cv_sel,
	 input wire signed [15:0] x_in, // q1.15 format//1(sign),15(Fractional)//
	 input wire signed [15:0] y_in, // q1.15 format
	 input wire signed [15:0] yn_cv,// q1.15 format
	 input [7:0] N, //No_of_iterations
	 output reg cv_calc_end, 
	 output reg di_valid, 
	 output reg [31:0] di_micro_rot,
	 output reg [1:0] quadrant,
	 output signed [15:0] cv_2Rminus1,//q1.15 format
	 output [15:0] r,//q1.15 format
   output l,
	 output reg signed [15:0] phi//q3.13 format
    );
	 

// Generate table of arctan values
wire signed [15:0] atan_table [0:15]; // q1.15
                        
assign atan_table[00] =	16'h6487; // 45.000 degrees -> atan(2^0)
assign atan_table[01] =  16'h3B58; // 26.565 degrees -> atan(2^-1)
assign atan_table[02] =  16'h1F5B; // 14.036 degrees -> atan(2^-2)
assign atan_table[03] =  16'h0FEA; // atan(2^-3)
assign atan_table[04] = 	16'h07FD;
assign atan_table[05] = 	16'h03FF;
assign atan_table[06] = 	16'h01FF;
assign atan_table[07] = 	16'h00FF;
assign atan_table[08] = 	16'h007F;
assign atan_table[09] = 	16'h003F;
assign atan_table[10] = 	16'h001F;
assign atan_table[11] = 	16'h000F;
assign atan_table[12] = 	16'h0007;
assign atan_table[13] = 	16'h0003;
assign atan_table[14] = 	16'h0001;
assign atan_table[15] = 	16'h0000;


parameter width = 18;
parameter plus_pi = 18'h1921F;//or 19220//32'h6487ED51;//2 bit int,15Fractional 1 sign bit
parameter minus_pi = 18'h26DE0;//32'h6487ED51;//2 bit int,15Fractional 1 sign bit
parameter K = 18'h9B78;//0.6073 in q16 398000
	 
reg signed [width-1:0] x;// q3.15//1(sign),2(int),15(Fractional)
reg signed [width-1:0] y;
reg signed [width-1:0] z;		//q3.15 1(sign),2(int),15(Fractional)
reg signed [35:0] r_k;
reg l_valid;
reg [7:0] itn_cnt;
reg start_latch;

assign r = (r_k[31] == 1)? $unsigned({2'b00, r_k[31:18]}) : $unsigned({r_k[31],r_k[30:16]});//q1.15 r is unsigned value 
assign l = (r_k[31] == 1)? 1: 0; 

assign cv_2Rminus1	= ({r[15:0],1'b0}) - 16'h8000;
always @ (posedge clk or negedge rst)
begin
  if(!rst) begin
	  x 					<= 18'h0000;
	  y 					<= 18'h0000;
	  z					<= 18'h0000;
	  itn_cnt 			<= 8'h00;
	  di_valid			<= 1'b0;
	  cv_calc_end		<= 1'b0;
	  quadrant			<= 2'b00;
	  di_micro_rot 	<= 32'h00000000;
	  r_k 				<= 36'h000000000;
    l_valid <= 0;
	  phi 				<= 16'h0000;
	end
  else if(start) begin
		start_latch	<= 1'b1;	
		cv_calc_end	<= 1'b0;
		itn_cnt		<= 8'h00;
		di_micro_rot 	<= 32'h00000000;
		r_k 				<= 36'h000000000;
    l_valid <= 0;
		phi 				<= 16'h0000;
    if (x_in >= 0) begin // 1st or 4th Quadrant // y_in greater or lesser than 0
		  x	<= {{2{x_in[15]}},x_in};   // q3.15
		  y	<= {{2{y_in[15]}},y_in};  // q3.15
		  z 	<= cv_sel==1'b1 ? 18'hC90f:18'h0000 ;  //q3.15//@cv_sel_1 load 90degree
		  quadrant			<= 2'b00;
		end
    else if (y_in >= 0) begin// 2nd Quadrant // if x_in < 0, check y>0
		  x	<= -x_in;//Moving to 1st quadrant
		  y	<= y_in;
		  z 	<= 18'h0000;//plus_pi;
		  quadrant			<= 2'b10;
		end
    else begin // 3rd quadrant
		  x	<= -x_in;//Moving to 1st quadrant
		  y	<= -y_in;
		  z 	<= 18'h0000;//minus_pi;
		  quadrant			<= 2'b11;
		end
	end
  else begin//!start
		if((start_latch)) begin
			if(itn_cnt<N) begin
			  x <= x - (y < yn_cv ? (y >>> itn_cnt) : -(y >>> itn_cnt));
			  y <= y + (y < yn_cv ? (x >>> itn_cnt) : -(x >>> itn_cnt));
			  z <= z - (y < yn_cv ? {2'b0,atan_table[itn_cnt]} : -{2'b0,atan_table[itn_cnt]});
			  itn_cnt	<= itn_cnt + 1;
				if(!cv_sel)
				  di_micro_rot[itn_cnt]	<= (y < yn_cv ? 0 : 1);// micro_rot = not di
				else begin
					if(itn_cnt==0)
					  di_micro_rot[0]			<= (y < yn_cv ? 0 : 1);// micro_rot = not di
					else
					  di_micro_rot[itn_cnt]	<= (y < yn_cv ? 1 : 0);// micro_rot = not(not di)
				end
			  di_valid	<= 1;
			end	
			else begin
			  r_k			<= K*x;//q2.16 * q3.15 = q5.31  //	
				if(quadrant	== 2'b10)
				  phi			<= 16'h6487 - z[17:2];//180-z
				else if(quadrant	== 2'b11)
				  phi			<= 16'h9B78 + z[17:2];//-180+z
				else	// 1st/4th quad
				  phi			<= z[17:2];//q3.13	
			  di_valid		<= 0;
			  cv_calc_end	<= 1'b1;
			  start_latch	<= 0;
			end
		end
		else if(cv_calc_end) begin
		  cv_calc_end	<= 1'b0;	
		end
	end	
end

endmodule
