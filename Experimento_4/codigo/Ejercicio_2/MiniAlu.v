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
    
    reg [9:0] TecRead;

    wire mIzq,mDer,mAbajo,mArriba;
    
    wire [10:0] iReadCol;
    wire [9:0] iReadRow;
    wire [2:0] RGB_out_template;
    wire [2:0] RGB_out_moving_square;
    wire red_square;
	 wire bandera;


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
	 
	Teclado tec1(PS2_CLK,PS2_DATA, Reset,mIzq,mDer,mArriba,mAbajo,bandera);
	 
// Se instancia el generador de senales

	VH_GENERATOR vh_generator(
		.Clock_25(Clock_25),
		.Reset(Reset),
		.h_synch(VGA_HSYNC),
		.v_synch(VGA_VSYNC),
		.pixel_count(iReadCol),
		.line_count(iReadRow)
		);

//Se suprimen los rebotes
wire up,down,left,right;
DeBounce debouncing_up(Clock_25,Reset,BTN_NORTH,up);
DeBounce debouncing_down(Clock_25,Reset,BTN_SOUTH,down);
DeBounce debouncing_left(Clock_25,Reset,BTN_WEST,left);
DeBounce debouncing_right(Clock_25,Reset,BTN_EAST,right);





//Se instancia el bloque que lleva la cuenta de donde esta el cuadrado rojo
moving_square moving_square (
	.Reset (Reset),
	.iReadCol(iReadCol),
	.iReadRow(iReadRow),
	.button_up(up),
	.button_down(down),
	.button_left(left),
	.button_right(right),
	/*.button_up(BTN_NORTH),
	.button_down(BTN_SOUTH),
	.button_left(BTN_WEST),
	.button_right(BTN_EAST),*/
	/*.button_up(mArriba),
	.button_down(mAbajo),
	.button_left(mIzq),
	.button_right(mDer),
	.bandera(bandera),*/
	.RGB_out(RGB_out_moving_square),
	.show_square(red_square)
	);


endmodule


//Juego
module moving_square (
	input wire Reset,
	input wire [10:0] iReadCol,
   input wire [9:0] iReadRow,
	input wire button_up,
	input wire button_down,
	input wire button_left,
	input wire button_right,
	//input wire bandera,
	output wire [2:0] RGB_out,
	output reg show_square
);

	integer square_width = `WIDTH_SIZE_RES/7;
	integer square_height = `HEIGHT_SIZE_RES/7;
	reg [2:0] squareX_position = 3'b011;
	reg [2:0] squareY_position = 3'b011;
	assign RGB_out = 3'b100;
	
		
	always @ (posedge button_up or posedge button_down) begin
		if (button_down)
			squareY_position = squareY_position +1;
		else
			squareY_position = squareY_position -1;
	end
	
	always @ (posedge button_left or posedge button_right) begin
		if (button_right)
			squareX_position = squareX_position +1;
		else
			squareX_position = squareX_position -1;
	end
	
	/*always @ (posedge button_left or posedge button_right or posedge Reset) begin
		if (button_right)
			squareX_position = squareX_position +1;
		else if (Reset)
			squareX_position =3'b011;
		else
			squareX_position = squareX_position -1;
	end*/
	

	
	always @ (*) begin
		if ((iReadCol >= square_width*squareX_position) && (iReadCol < square_width*(squareX_position+1))
				&& (iReadRow >= square_height*squareY_position) && (iReadRow < square_height*(squareY_position+1)) )
			show_square = 1;
		else
			show_square =0;
	
	end
	


endmodule


module  DeBounce 
    (
    input   clk, n_reset, button_in,        // inputs
    output reg DB_out
    );
     
    /*
    Parameter N defines the debounce time. Assuming 50 KHz clock,
    the debounce time is 2^(11-1)/ 50 KHz = 20 ms
     
    For 50 MHz clock increase value of N accordingly to 21.
     
    */
    parameter N = 11 ;      
 
    reg  [N-1 : 0]  delaycount_reg;                     
    reg  [N-1 : 0]  delaycount_next;
     
    reg DFF1, DFF2;                                 
    wire q_add;                                     
    wire q_reset;
 
        always @ ( posedge clk )
        begin
            if(n_reset ==  1'b0) // At reset initialize FF and counter 
                begin
                    DFF1 <= 1'b0;
                    DFF2 <= 1'b0;
                    delaycount_reg <= { N {1'b0} };
                end
            else
                begin
                    DFF1 <= button_in;
                    DFF2 <= DFF1;
                    delaycount_reg <= delaycount_next;
                end
        end
     
     
    assign q_reset = (DFF1  ^ DFF2); // Ex OR button_in on conecutive clocks
                                     // to detect level change 
                                      
    assign  q_add = ~(delaycount_reg[N-1]); // Check count using MSB of counter         
     
 
    always @ ( q_reset, q_add, delaycount_reg)
        begin
            case( {q_reset , q_add})
                2'b00 :
                        delaycount_next <= delaycount_reg;
                2'b01 :
                        delaycount_next <= delaycount_reg + 1;
                default :
                // In this case q_reset = 1 => change in level. Reset the counter 
                        delaycount_next <= { N {1'b0} };
            endcase    
        end
     
     
    always @ ( posedge clk )
        begin
            if(delaycount_reg[N-1] == 1'b1)
                    DB_out <= DFF2;
            else
                    DB_out <= DB_out;
        end
         
endmodule



