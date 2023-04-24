`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:17:13 04/15/2023
// Design Name:   Mux_Controller
// Module Name:   /home/anu/work/Courses_IITM/EE5331/PROJECT/Design/Square_root_by_CORDIC/Complex_Square_Root/tb_Mux_controller.v
// Project Name:  Complex_Square_Root
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mux_Controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Mux_controller;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] x_in;
	reg [15:0] y_in;
	reg start;
	reg cv_calc_end;
	reg cr_calc_end;
	reg cv_di_valid;
	reg [31:0] cv_di_microt;
	reg [15:0] cv_2Rminus1;
	reg [15:0] cr_cos_theta;
	reg [15:0] cr_sin_theta;

	// Outputs
	wire [31:0] cr_di_microt;
	wire start_cv;
	wire start_cr;
	wire [15:0] xin_cv;
	wire [15:0] yin_cv;
	wire [15:0] yn_cv;
	wire [15:0] xin_cr;
	wire [15:0] yin_cr;
	wire [15:0] cmplx_sqrt_real;
	wire [15:0] cmplx_sqrt_imag;
	wire cmplx_sqrt_valid;

	// Instantiate the Unit Under Test (UUT)
	Mux_Controller uut (
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
		.cr_cos_theta(cr_cos_theta), 
		.cr_sin_theta(cr_sin_theta), 
		.cr_di_microt(cr_di_microt), 
		.start_cv(start_cv), 
		.start_cr(start_cr), 
		.xin_cv(xin_cv), 
		.yin_cv(yin_cv), 
		.yn_cv(yn_cv), 
		.xin_cr(xin_cr), 
		.yin_cr(yin_cr), 
		.cmplx_sqrt_real(cmplx_sqrt_real), 
		.cmplx_sqrt_imag(cmplx_sqrt_imag), 
		.cmplx_sqrt_valid(cmplx_sqrt_valid)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		x_in = 0;
		y_in = 0;
		start = 0;
		cv_calc_end = 0;
		cr_calc_end = 0;
		cv_di_valid = 0;
		cv_di_microt = 0;
		cv_2Rminus1 = 0;
		cr_cos_theta = 0;
		cr_sin_theta = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

