`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:58:21 04/12/2023 
// Design Name: 
// Module Name:    Top_Complex_SquareRoot 
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
module Top_Complex_SquareRoot(
    input clk,
    input rst,
    input start,
	 input [7:0] N, //No_of_iterations
	 input wire signed [15:0] x_in,
	 input wire signed [15:0] y_in,
	 output signed [15:0] cmplx_sqrt_real_out,
	 output signed [15:0] cmplx_sqrt_img_out,
	 output cmplx_sqrt_valid
    );

wire start_cv;
wire start_cr;
wire cv_sel;
wire cv_di_valid;
wire cv_calc_end;
wire cr_calc_end;
wire [31:0] cv_di_microt;
wire [31:0] cr_di_microt;
wire [1:0]  quadrant;
wire signed [15:0] cr_cos_theta;
wire signed [15:0] cr_sin_theta;
wire signed [15:0] xin_cv;
wire signed [15:0] yin_cv;
wire signed [15:0] xin_cr;
wire signed [15:0] yin_cr;
wire signed [15:0] yn_cv;
wire signed [15:0] cv_2Rminus1;
wire l;


	CV_CORDIC CV (
		.clk(clk), 
		.rst(rst), 
		.start(start_cv), 
		.x_in(xin_cv), 
		.y_in(yin_cv), 
		.yn_cv(yn_cv),
		.cv_sel(cv_sel),
		.N(N), 
		.di_valid(cv_di_valid), 
		.di_micro_rot(cv_di_microt), 
		.quadrant(quadrant), 
		.cv_2Rminus1(cv_2Rminus1),
    .l(l),
		.cv_calc_end(cv_calc_end),
		.r(), 
		.phi()
	);

	CR_CORDIC CR (
		.clk(clk), 
		.rst(rst), 
		.start(start_cr), 
		.x_in(xin_cr), 
		.y_in(yin_cr), 
		.theta_x_di(cr_di_microt), 
		.N(N), 
		.cr_calc_end(cr_calc_end),
		.cos_theta(cr_cos_theta), 
		.sin_theta(cr_sin_theta)
	);

	Mux_Controller mux2_1 (
		.clk(clk), 
		.rst(rst), 
		.x_in(x_in), 
		.y_in(y_in), 
		.start(start), 
		.cv_calc_end(cv_calc_end), 
		.cr_calc_end(cr_calc_end), 
		.cv_di_valid(cv_di_valid), 
		.cv_di_microt(cv_di_microt), 
		.cv_2Rminus1(cv_2Rminus1), 
    .l(l),
		.cr_cos_theta(cr_cos_theta), 
		.cr_sin_theta(cr_sin_theta), 
		.cr_di_microt(cr_di_microt), 
		.quadrant(quadrant),
		.start_cv(start_cv), 
		.start_cr(start_cr), 
		.cv_sel(cv_sel), 
		.xin_cv(xin_cv), 
		.yin_cv(yin_cv), 
		.yn_cv(yn_cv), 
		.xin_cr(xin_cr), 
		.yin_cr(yin_cr), 
		.cmplx_sqrt_real(cmplx_sqrt_real_out), 
		.cmplx_sqrt_imag(cmplx_sqrt_img_out), 
		.cmplx_sqrt_valid(cmplx_sqrt_valid)
	);
endmodule
