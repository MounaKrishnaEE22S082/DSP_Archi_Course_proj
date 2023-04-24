`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:09:18 04/14/2023 
// Design Name: 
// Module Name:    Mux_Controller 
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
module Mux_Controller(
    input clk,
    input rst,
    input signed [15:0] x_in,
    input signed [15:0] y_in,
    input start,
	  input cv_calc_end,
	  input cr_calc_end,
    input cv_di_valid,
    input [31:0] cv_di_microt,
    input signed [15:0] cv_2Rminus1,
    input l,
    input signed [15:0] cr_cos_theta,
    input signed [15:0] cr_sin_theta,
	  input [1:0] quadrant,
    output reg [31:0] cr_di_microt,
    output reg start_cv,
    output reg start_cr,
    output reg cv_sel,
    output reg signed [15:0] xin_cv,
    output reg signed [15:0] yin_cv,
    output reg signed [15:0] yn_cv,
    output reg signed [15:0] xin_cr,
    output reg signed [15:0] yin_cr,
    output reg signed [15:0] cmplx_sqrt_real,
    output reg signed [15:0] cmplx_sqrt_imag,
    output reg cmplx_sqrt_valid
    );
	 
	 
reg [2:0] current_state;
reg [31:0] cv_di_microt_psi;
reg [1:0] in_quadrant;
reg set_bit;
reg cv_2Rminus1_sign;
reg l_reg;

parameter S0=3'b000;
parameter S1=3'b001;
parameter S2=3'b010;
parameter S3=3'b011;

always @ (posedge clk or negedge rst)
begin
	if(!rst) begin
	  start_cv					<= 1'b0;
	  start_cr					<= 1'b0;
	  cv_sel					<= 1'b0;
	  cmplx_sqrt_valid		<= 1'b0;
	  cmplx_sqrt_valid		<= 1'b0;
	  in_quadrant  			<= 2'b00;
	  cv_di_microt_psi  	<= 32'h00000000;
	  cr_di_microt		  	<= 32'h00000000;
	  xin_cv					<= 16'h0000;
	  yin_cv					<= 16'h0000;
	  yn_cv						<= 16'h0000;
	  xin_cr					<= 16'h0000;
	  yin_cr					<= 16'h0000;
	  cmplx_sqrt_real   	<= 16'h0000;
	  cmplx_sqrt_imag   	<= 16'h0000;
	end
	else begin	
		case(current_state)
		S0: begin
		  start_cv					<= 1'b0;
		  start_cr					<= 1'b0;
		  cv_sel					<= 1'b0;
		  cmplx_sqrt_valid		<= 1'b0;
		  set_bit					<= 1'b0;
		  in_quadrant				<= 2'b00;
		  cv_di_microt_psi  	<= 32'h00000000;
		  cr_di_microt  			<= 32'h00000000;
		  xin_cv					<= 16'h0000;
		  yin_cv					<= 16'h0000;
		  yn_cv						<= 16'h0000;
		  xin_cr					<= 16'h0000;
		  yin_cr					<= 16'h0000;
      l_reg <=0;
      cv_2Rminus1_sign <= 0;
		end
		
		S1: begin
		  xin_cv	<= x_in;
		  yin_cv	<= y_in;
		  yn_cv		<= 16'h0000;//0
		  cv_sel	<= 1'b0;
		  set_bit	<= 1'b1;
			if(!set_bit)
			  start_cv	<= 1'b1;
			else
			  start_cv	<= 1'b0;
		end
		
		S2: begin
			if(cv_calc_end && (!cv_sel)) begin
			  cv_di_microt_psi	<= cv_di_microt;
			  xin_cv	<= 16'h4DB9;//0.6073//1 //16'h136F--in q13
			  yin_cv	<= 16'h0000;//0
			  yn_cv		<= cv_2Rminus1;//2R-1
        l_reg <= l;
        cv_2Rminus1_sign <= cv_2Rminus1[15];
			  in_quadrant	<= quadrant;	
			  set_bit	<= 1'b0;
			  cv_sel	<= 1'b1;
			  start_cv	<= 1'b1;
			end
			else
			  start_cv	<= 1'b0;
			if((cv_di_valid) && (!set_bit)) begin
			  xin_cr	<= 16'h7fff;//1
			  yin_cr	<= 16'h0000;//0
			  cr_di_microt	<= cv_di_microt;//phi
			  start_cr	<= 1'b1;
			  set_bit	<= 1'b1;
			end
			else if(cr_calc_end) begin
        if (cv_2Rminus1_sign == 1)
          xin_cr			<= cr_sin_theta;//cos theta=rootR
        else
			    xin_cr			<= cr_cos_theta;//cos theta=rootR
			  yin_cr			<= 16'h0000;//0
			  cr_di_microt	<= cv_di_microt_psi;//psi/2
			  start_cr	<= 1'b1;
			end
			else begin
			  start_cr			<= 1'b0;
			  cr_di_microt	<= cv_di_microt;//phi
			end
		end
		S3: begin
			cv_sel	<= 1'b0;
			start_cr	<= 1'b0;
			if(cr_calc_end)
			begin
				cmplx_sqrt_valid	<= 1'b1;
				if(in_quadrant==2'b10) begin
				  cmplx_sqrt_real	<= cr_sin_theta << l_reg;
				  cmplx_sqrt_imag	<= cr_cos_theta << l_reg;
				end
				else if(in_quadrant==2'b11) begin
				  cmplx_sqrt_real	<= cr_sin_theta << l_reg;
				  cmplx_sqrt_imag	<= -cr_cos_theta << l_reg;
				end
				else begin
				  cmplx_sqrt_real	<= cr_cos_theta << l_reg;
				  cmplx_sqrt_imag	<= cr_sin_theta << l_reg;
				end
			end
		end	
		endcase	
  end //else part end
end //always end

always @ (posedge clk or negedge rst)
begin
	if(!rst)
	begin
	current_state	<= S0;
	end
	else
	begin
		case(current_state)
		S0: if(start)
		  current_state	<= S1;
		
		S1: 
		if(start_cv)
		  current_state	<= S2;
		
		S2: if(cr_calc_end) //if((cv_di_valid) && (!set_bit))
		  current_state	<= S3;
		
		S3: if(cr_calc_end)
		  current_state	<= S0;//S4
		endcase
	end
end


endmodule
