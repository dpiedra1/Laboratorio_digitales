`timescale 1ns / 1ps
`include "VGA_DEFINES.v"
`include "Teclado.v"

module MiniAlu(
	input wire Clock,
	input wire Reset,
	input wire BTN_EAST,
	input wire BTN_NORTH,
	input wire BTN_SOUTH,
	input wire BTN_WEST,
	input wire PS2_DATA,
	input wire PS2_CLK,
	output wire VGA_HSYNC,
	output wire VGA_VSYNC,
	output wire VGA_RED,
	output wire VGA_GREEN,
	output wire VGA_BLUE
	);

	
    reg Clock_25;
    
    reg [9:0] TecRead:

    wire mIzq,mDer,mAbajo,mArriba;
    
    wire [10:0] iReadCol;
    wire [9:0] iReadRow;
    wire [2:0] RGB_out_template;
    wire [2:0] RGB_out_moving_square;
    wire red_square; 


	//MUX
    assign VGA_RED = (red_square) ? RGB_out_moving_square[2]:RGB_out_template[2];
    assign VGA_BLUE = (red_square)? RGB_out_moving_square[1]:RGB_out_template[1];
    assign VGA_GREEN =(red_square)? RGB_out_moving_square[0]:RGB_out_template[0];
   
// Generacion del clock

    always @ (posedge Clock, posedge Reset)
        begin
            if (Reset) Clock_25 <= 1'b0;
            else Clock_25 <= ~Clock_25;
        end
    
	
	//Se instancia el color de fondo 
	bg_template bg_template (
		.iReadCol(iReadCol),
		.iReadRow(iReadRow),
		.RGB_out(RGB_out_template)
	);
	 
	Teclado tec1(PS2_CLK,PS2_DATA, TecRead, Reset,mIzq,mDer,mArriba,mAbajo);
	 
// Se instancia el generador de senales

	VH_GENERATOR vh_generator(
		.Clock_25(Clock_25),
		.Reset(Reset),
		.h_synch(VGA_HSYNC),
		.v_synch(VGA_VSYNC),
		.pixel_count(iReadCol),
		.line_count(iReadRow)
		);

//Se instancia el bloque que lleva la cuenta de donde esta el cuadrado rojo
//reg BTN_NORTH = 0;
//reg BTN_SOUTH = 0; 
//reg BTN_EAST = 0;
//reg BTN_WEST = 0;

moving_square moving_square (
	.iReadCol(iReadCol),
	.iReadRow(iReadRow),
	/*.button_up(BTN_NORTH),
	.button_down(BTN_SOUTH),
	.button_left(BTN_WEST),
	.button_right(BTN_EAST),*/
	.button_up(mArriba),
	.button_down(mAbajo),
	.button_left(mIzq),
	.button_right(mDer),
	.RGB_out(RGB_out_moving_square),
	.show_square(red_square)
	);


endmodule


//Juego
module moving_square (
	input wire [10:0] iReadCol,
   input wire [9:0] iReadRow,
	input wire button_up,
	input wire button_down,
	input wire button_left,
	input wire button_right,
	output wire [2:0] RGB_out,
	output reg show_square
);

	integer square_width = `WIDTH_SIZE_RES/7;
	integer square_height = `HEIGHT_SIZE_RES/7;
	reg [2:0] squareX_position =3'b011;
	reg [2:0] squareY_position =3'b100;
	assign RGB_out = 3'b100;
	
	
	always @ (posedge button_up or posedge button_down) begin
		if (button_up)
			squareY_position = squareY_position -1;
		else
			squareY_position = squareY_position +1;
	end
	
	always @ (posedge button_left or posedge button_right) begin
		if (button_left)
			squareX_position = squareX_position -1;
		else
			squareX_position = squareX_position +1;
	end
	

	
	always @ (*) begin
		if ((iReadCol >= square_width*squareX_position) && (iReadCol < square_width*(squareX_position+1))
				&& (iReadRow >= square_height*squareY_position) && (iReadRow < square_height*(squareY_position+1)) )
			show_square = 1;
		else
			show_square =0;
	
	end
	


endmodule

