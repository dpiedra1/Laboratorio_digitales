`include "VGA_DEFINES.v"
`define background_color 3'b000 //negro



module bg_template(
	input wire [10:0] iReadCol,
	input wire [9:0]  iReadRow,
	output wire [2:0]  RGB_out   
	);
	
	assign RGB_out = `background_color;
	
	
endmodule
