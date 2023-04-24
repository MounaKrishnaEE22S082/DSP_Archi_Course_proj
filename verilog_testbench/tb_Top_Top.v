module tb_Top_Top;
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

  reg[31:0] read_data [0:2047];

  integer i;
  integer out_file;
  reg [7:0] cnt_cycles;

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

    //$dumpfile("test.vcd");
    //$dumpvars(0,tb_Top_Top);

    $readmemh("verilog_testbench/inputs.txt", read_data);
    out_file = $fopen("verilog_testbench/got_outputs.txt", "w");

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

    for (i = 0; i<2048; i=i+1) begin
      x_in <= read_data[i][31:16];
      y_in <= read_data[i][15:0];
      //$display("x: %h", read_data[i][31:16]);
      //$display("y: %h", read_data[i][15:0]);
      start <= 1;
      #10;
      start <= 0;
      #800;
      $fwriteh(out_file, cmplx_sqrt_real_out);
      $fwriteh(out_file, cmplx_sqrt_img_out);
      $fdisplay(out_file);
    end
    $fclose(out_file);
    $finish;
  end
endmodule
