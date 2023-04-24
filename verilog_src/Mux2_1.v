`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:07 04/13/2023 
// Design Name: 
// Module Name:    Mux2_1 
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
module Mux2_1(
    input [15:0] A,
    input [15:0] B,
    input [15:0] Sel,
    output [15:0] Z
    );


assign Z= Sel? B : A;

endmodule
