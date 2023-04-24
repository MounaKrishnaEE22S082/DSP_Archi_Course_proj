`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:19:43 04/09/2023
// Design Name:   CV_CORDIC
// Module Name:   /home/anu/work/Courses_IITM/EE5331/PROJECT/Design/Square_root_by_CORDIC/Complex_Square_Root/tb_CV_CORDIC.v
// Project Name:  Complex_Square_Root
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CV_CORDIC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_CV_CORDIC;

	// Inputs
	reg clk=0;
	reg rst;
	reg start;
	reg signed [15:0] x_in;
	reg signed [15:0] y_in;
	reg signed [15:0] yn_cv;
	
	reg [7:0] N;

	// Outputs
	wire [15:0] cv_2Rminus1;
	wire [15:0] r;//q3.13 format
	wire [15:0] phi;//q3.13 format

	// Instantiate the Unit Under Test (UUT)
	CV_CORDIC uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.x_in(x_in), 
		.y_in(y_in), 
		.yn_cv(yn_cv), 
		.N(N), 
		.r(r), 
		.cv_2Rminus1(cv_2Rminus1), 
		.phi(phi)
	);

	always
	begin
	#5 clk = !clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		start = 0;
		x_in = 0;
		y_in = 0;
		N = 0;
		yn_cv = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
        
		// Add stimulus here
		N		<= 'd16;
		x_in	<= 16'h6000;     	//+0.75
		y_in	<= 16'h370A;		//+0.43
		//repeat(2) @(posedge clk)
//		x_in	<= 16'h1800;		//+0.75
//		y_in	<= 16'hF23D;		//-0.43
//		x_in	<= 16'hE800;		//-0.75
//		y_in	<= 16'hDC2;			//+0.43
//		x_in	<= 16'hE800;		//-0.75
//		y_in	<= 16'hF23D;		//-0.43

		start	<= 1;
		#10;
		
		start	<= 0;
	end
      
endmodule

//		x_in	<= 16'h1800;     	//+0.75
//		y_in	<= 16'hDC2;			//+0.43
		//repeat(2) @(posedge clk)
//		x_in	<= 16'h1800;		//+0.75
//		y_in	<= 16'hF23D;		//-0.43
//		x_in	<= 16'hE800;		//-0.75
//		y_in	<= 16'hDC2;			//+0.43
//		x_in	<= 16'hE800;		//-0.75
//		y_in	<= 16'hF23D;		//-0.43