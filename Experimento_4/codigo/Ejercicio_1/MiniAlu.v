`timescale 1ns / 1ps
`include "VGA_DEFINES.v"

module MiniAlu(
	input wire Clock,
	input wire Reset,
	output wire VGA_HSYNC,
	output wire VGA_VSYNC,
	output wire VGA_RED,
	output wire VGA_GREEN,
	output wire VGA_BLUE
	);

	
    reg Clock_25;
    
    
    
    wire [10:0] iReadCol;
    wire [9:0] iReadRow;

    
    

// Generacion del clock

    always @ (posedge Clock, posedge Reset)
        begin
            if (Reset) Clock_25 <= 1'b0;
            else Clock_25 <= ~Clock_25;
        end
    
	// RAM de video
	reg [10:0] iWriteCol =0;
	reg [9:0] iWriteRow =0;
	reg [2:0] RGB_to_write = 3'b000;
	reg rWriteEnable_RAM_VGA = 0;

	wire [2:0] RGB_RAM_out;
	assign VGA_RED = RGB_RAM_out[2];
	assign VGA_GREEN = RGB_RAM_out[1];
	assign VGA_BLUE = RGB_RAM_out[0];


	RAMWrapper RAMWrapper(
		.CLK(Clock_25),
		.Reset(Reset),
		.iWriteEnable(rWriteEnable_RAM_VGA),
		.iReadCol(iReadCol),
		.iReadRow(iReadRow),
		.iWriteCol(iWriteCol),
		.iWriteRow(iWriteRow),
		.RGB_in(RGB_to_write),
		.RGB_out(RGB_RAM_out)
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



endmodule
