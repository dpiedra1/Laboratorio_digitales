`timescale 1ns / 1ps
`include "VGA_DEFINES.v"

module Pong(
	input wire Clock,
	input wire Reset,
	input wire BTN_EAST,
	input wire BTN_NORTH,
	input wire BTN_SOUTH,
	input wire BTN_WEST,
	output wire VGA_HSYNC,
	output wire VGA_VSYNC,
	output wire VGA_RED,
	output wire VGA_GREEN,
	output wire VGA_BLUE
	);
	
	reg Clock_25;
    
	// Generacion del clock
	always @ (posedge Clock, posedge Reset)
		begin
			if (Reset) Clock_25 <= 1'b0;
				else Clock_25 <= ~Clock_25;
		end 
    
    
    
    
    wire [10:0] iReadCol;
    wire [9:0] iReadRow;
    wire [2:0] RGB_out_template;
    wire [2:0] RGB_out_bar_ball;
    wire display_bar_or_ball;
    
    //Se instancia el color de fondo 
	bg_template bg_template (
		.iReadCol(iReadCol),
		.iReadRow(iReadRow),
		.RGB_out(RGB_out_template)
	);
	 
	 
	 
// Se instancia el generador de senales

	VH_GENERATOR vh_generator(
		.Clock_25(Clock_25),
		.Reset(Reset),
		.h_synch(VGA_HSYNC),
		.v_synch(VGA_VSYNC),
		.pixel_count(iReadCol),
		.line_count(iReadRow)
		);
		
		
	bar_ball bar_ball (
	.iReadCol(iReadCol),
	.iReadRow(iReadRow),
	.Clock(Clock_25),
	.Reset(Reset),
	.button_up(BTN_NORTH),
	.button_down(BTN_SOUTH),
	.button_left(BTN_WEST),
	.button_right(BTN_EAST),
	.RGB_out(RGB_out_bar_ball),
	.display_bar_or_ball(display_bar_or_ball)
	);
    
   //MUX
   assign VGA_RED = (display_bar_or_ball) ? RGB_out_bar_ball[2]:RGB_out_template[2];
   assign VGA_BLUE = (display_bar_or_ball)? RGB_out_bar_ball[1]:RGB_out_template[1];
   assign VGA_GREEN =(display_bar_or_ball)? RGB_out_bar_ball[0]:RGB_out_template[0]; 
	
	
endmodule





