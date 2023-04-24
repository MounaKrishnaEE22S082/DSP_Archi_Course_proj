`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:48:06 04/10/2023 
// Design Name: 
// Module Name:    CR_CORDIC 
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

// Using doubly Pipeline we are finding cos(theta/2)
module CR_CORDIC(
    input clk,
    input rst,
	 input start,
	 input wire signed [15:0] x_in, // q1.15 format//1(sign),15(Fractional)//
	 input wire signed [15:0] y_in,//q1.15 format
	 input wire [31:0] theta_x_di,
	 input [7:0] N, //No_of_iterations
	 output reg cr_calc_end,
	 output signed [15:0] cos_theta,//q1.15 format
	 output signed [15:0] sin_theta//q1.15 format
    );
	 
//parameter width = 18;
wire [31:0] theta_zero_di; 
assign theta_zero_di = 32'b00110011100100110011000011010001; //di=01110100111100110011011000110011--> reverse it --> 11001100011011001100111100101110	
								// 11001100011011001100111100101110 --> inverse it --> 
								// 00110011100100110011000011010001
reg signed [17:0] x;
reg signed [17:0] y;
reg signed [33:0] x_scale;
reg signed [33:0] y_scale;
//reg [2*width-1:0] K;
reg signed [31:0] K;//q2.30
reg [7:0] itn_cnt;
reg [7:0] rot_cnt;
reg start_latch;

// Generate table of arctan values
wire signed [15:0] cos_table [0:7];
                          

assign cos_table[00] = 16'h5A82; // 45.000 degrees -> cos(atan(2^0))//q1.15
assign cos_table[01] = 16'h727C; // 26.565 degrees -> cos atan(2^-1)
assign cos_table[02] = 16'h7C2D; // 14.036 degrees -> cos atan(2^-2)
assign cos_table[03] = 16'h7F02; // atan(2^-3)
assign cos_table[04] = 16'h7FC0;
assign cos_table[05] = 16'h7FF0;
assign cos_table[06] = 16'h7FFC;
assign cos_table[07] = 16'h7FFF;
  
  
//  	assign cos_theta = 	{x_scale[31],x_scale[27:13]};//q1.15
//	assign sin_theta = 	{y_scale[31],y_scale[27:13]};  	
	
	assign cos_theta = 	{x_scale[33],x_scale[29:15]};//q1.15
	assign sin_theta = 	{y_scale[33],y_scale[29:15]};

always @ (posedge clk or negedge rst) begin
  if(!rst) begin
	  x 			<= 18'h0000;
	  y 			<= 18'h0000;
	  x_scale 	<= 32'h00000000;
	  y_scale 	<= 32'h00000000;
	  itn_cnt 	<= 8'h00;
	  rot_cnt 	<= 8'h00;
	  K			<= 32'h00000000;
	  start_latch	<= 1'b0;	
	  cr_calc_end	<= 1'b0;	
	end
  else if(start) begin
	  x	<= {{2{x_in[15]}},x_in};   // q3.15//1sign 2int 15 fractional bit
	  y	<= {{2{y_in[15]}},y_in};  // q3.15
	  x_scale 			<= 34'h00000000;
	  y_scale 			<= 34'h00000000;
	  start_latch		<= 1'b1;	
	  cr_calc_end		<= 1'b0;
	  rot_cnt			<= 8'h00;
	  itn_cnt 			<= 8'h00;
	  K					<= 32'h40000000;// 'h40000000=1//q2.30
	end
  else begin//!start
		if((start_latch)) begin
			if(itn_cnt<N) begin
			  itn_cnt	<= itn_cnt + 1;
        if(~(theta_x_di[itn_cnt]^theta_zero_di[itn_cnt]))	begin//xnor(theta_x_di[itn_cnt],theta_zero_di[itn_cnt])=1 //theta_x_di[itn_cnt]==0
				  x <= x - (theta_x_di[itn_cnt] == 0 ? -(y >>> itn_cnt) : (y >>> itn_cnt));
				  y <= y + (theta_x_di[itn_cnt] == 0 ? -(x >>> itn_cnt) : (x >>> itn_cnt));
				  K <= itn_cnt<8 ? ({K[30],K[29:15]}*cos_table[itn_cnt]) : K;//k=q2.30//K=32'h26DC5D64 for 0.6072
				  rot_cnt	<= rot_cnt +1;
				end
			end
			else begin
			  x_scale	<= $signed({K[30],K[29:15]})*x;//q1.15 * q3.15=q4.30
			  y_scale  <= $signed({K[30],K[29:15]})*y;	
			  cr_calc_end	<= 1'b1;
			  start_latch	<= 0;
			end
		end	
		else if(cr_calc_end) begin
		  cr_calc_end	<= 1'b0;	
		end
	end	
end
endmodule
