`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:51:58 04/10/2023
// Design Name:   CR_CORDIC
// Module Name:   /home/anu/work/Courses_IITM/EE5331/PROJECT/Design/Square_root_by_CORDIC/Complex_Square_Root/tb_CR_CORDIC.v
// Project Name:  Complex_Square_Root
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CR_CORDIC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_CR_CORDIC;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [15:0] x_in;
	reg [15:0] y_in;
	reg [31:0] theta_x_di;
	reg [7:0] N;

	// Outputs
	wire [15:0] cos_theta;
	wire [15:0] sin_theta;

	// Instantiate the Unit Under Test (UUT)
	CR_CORDIC uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.x_in(x_in), 
		.y_in(y_in), 
		.theta_x_di(theta_x_di), 
		.N(N), 
		.cos_theta(cos_theta), 
		.sin_theta(sin_theta)
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
		theta_x_di = 0;
		N = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
        
		// Add stimulus here
		N		<= 'd32;
		theta_x_di	<= 32'b10010010011111000101111110111011;//for 70degree
		x_in	<= 16'h7fff;		//1
		y_in	<= 16'h0000;		//0
		
		start	<= 1;
		#10;
		
		start	<= 0;

	end
      
endmodule

