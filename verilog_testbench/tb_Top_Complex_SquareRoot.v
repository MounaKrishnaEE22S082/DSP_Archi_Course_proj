`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:43:15 04/12/2023
// Design Name:   Top_Complex_SquareRoot
// Module Name:   /home/anu/work/Courses_IITM/EE5331/PROJECT/Design/Square_root_by_CORDIC/Complex_Square_Root/tb_Top_Complex_SquareRoot.v
// Project Name:  Complex_Square_Root
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top_Complex_SquareRoot
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Top_Complex_SquareRoot;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [7:0] N;
	reg [15:0] x_in;
	reg [15:0] y_in;
	wire [15:0] cmplx_sqrt_real_out;
	wire [15:0] cmplx_sqrt_img_out;
	wire cmplx_sqrt_valid;
	reg signed [15:0] A;
	reg signed [15:0] B;
	reg signed [31:0] C;

	// Instantiate the Unit Under Test (UUT)
	Top_Complex_SquareRoot uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.N(N), 
		.x_in(x_in), 
		.y_in(y_in), 
		.cmplx_sqrt_real_out(cmplx_sqrt_real_out), 
		.cmplx_sqrt_img_out(cmplx_sqrt_img_out),
		.cmplx_sqrt_valid(cmplx_sqrt_valid)
	);
	always
	begin
	#5 clk = !clk;
	end
	
	initial begin

    $dumpfile("test.vcd");
    $dumpvars(0,tb_Top_Complex_SquareRoot);

		// Initialize Inputs
		clk = 0;
		rst = 0;
		start = 0;
		N = 0;
		x_in = 0;
		y_in = 0;


		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
        
		// Add stimulus here
		N		<= 'd16;
//		x_in_rootR	<= 16'h1800;     	//+0.75
//		y_in_rootR	<= 16'hDC2;			//+0.43
//		x_in_rootR	<= 16'h1800;		//+0.75
//		y_in_rootR	<= 16'hF23D;		//-0.43
//		x_in_rootR	<= 16'hE800;		//-0.75
//		y_in_rootR	<= 16'hDC2;			//+0.43
//		x_in_rootR	<= 16'hE800;		//-0.75
//		y_in_rootR	<= 16'hF23D;		//-0.43
//		x_in_cos_phi<= 16'h2000;		//1
//		y_in_cos_phi<= 16'h0000;	
//we find cos(29.83/2) = 0.966
//		A<=16'h8000;
//		B<=16'h0001;
//		#10;
//		C<= A*B;

		x_in	<= 16'h6000;     	//+0.75
		y_in	<= 16'h370a;		//+0.43
		start	<= 1;
		#10;
		start	<= 0;
		#800;
    //x_in  <= 16'h651f;
    //y_in  <= 16'hbd70;
    //start <= 1;
    //#10;
    //start <= 0;
    //#800;
    //x_in  <= 16'haf5c;
    //y_in  <= 16'h251e;
    //start <= 1;
    //#10;
    //start <= 0;
    //#800;
    //x_in  <= 16'hbc29;
    //y_in  <= 16'hc3d7;
    //start <= 1;
    //#10;
    //start <= 0;
    //#800;
    $finish;

		//x_in	<= 16'd19005;     	//+0.58
		//y_in	<= 16'd8847;		  //+0.27
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;
		//x_in	<= 16'd10485;     	//+0.32
		//y_in	<= 16'd12124;		  //+0.37
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;
		//x_in	<= 16'd22609;        //+0.69
		//y_in	<= 16'd23592;		  //+0.72
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;
//4t//h Quadrant		
		//x_in	<= 16'h6000;     	//+0.75
		//y_in	<= 16'd51446;		//-0.43
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;
		//x_in	<= 16'd10485;     	//+0.32
		//y_in	<= 16'd53411;		  //-0.37
		//start	<= 1;
		//#10;
		//start	<= 0;	
		//#800;		
//2n//d Quadrant		
		//x_in	<= 16'd40960;     	//-0.75
		//y_in	<= 16'h370A;		//+0.43
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;
//3r//d Quadrant		
		//x_in	<= 16'd40960;     	//-0.75
		//y_in	<= 16'd51446;		//-0.43
		//start	<= 1;
		//#10;
		//start	<= 0;
		//#800;

    //$finish;
	end
      
endmodule

