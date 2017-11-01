`include "VGA_DEFINES.v"

module bg_template(
	input wire [10:0] iReadCol,
	input wire [9:0]  iReadRow,
	output reg [2:0]  RGB_out
	);
	
	integer square_width = `WIDTH_SIZE_RES/7;
	integer square_height = `HEIGHT_SIZE_RES/7;
	reg [2:0] squareX_position;
	reg [2:0] squareY_position;
	
	
	//Para X
	always @(*) begin
		if (iReadCol < square_width)
			squareX_position = 3'b000;
		else if ( (iReadCol >= square_width) && (iReadCol < square_width*2)  )
			squareX_position = 3'b001;
		else if ( (iReadCol >= square_width*2) && (iReadCol < square_width*3)  )
			squareX_position = 3'b010;
		else if ( (iReadCol >= square_width*3) && (iReadCol < square_width*4)  )
			squareX_position = 3'b011;
		else if ( (iReadCol >= square_width*4) && (iReadCol < square_width*5)  )
			squareX_position = 3'b100;
		else if ( (iReadCol >= square_width*5) && (iReadCol < square_width*6)  )
			squareX_position = 3'b101;
		else
			squareX_position = 3'b110;
	
	
	end
	
	
	
	//Para Y
	always @(*) begin
		if (iReadRow < square_height)
			squareY_position = 3'b000;
		else if ( (iReadRow >= square_height) && (iReadRow < square_height*2)  )
			squareY_position = 3'b001;
		else if ( (iReadRow >= square_height*2) && (iReadRow < square_height*3)  )
			squareY_position = 3'b010;
		else if ( (iReadRow >= square_height*3) && (iReadRow < square_height*4)  )
			squareY_position = 3'b011;
		else if ( (iReadRow >= square_height*4) && (iReadRow < square_height*5)  )
			squareY_position = 3'b100;
		else if ( (iReadRow >= square_height*5) && (iReadRow < square_height*6)  )
			squareY_position = 3'b101;
		else
			squareY_position = 3'b110;
	
	
	end
	
	//Definiendo el color de salida RGB_out
	always @(*) begin
		if ((squareX_position[0] == 0)  && (squareY_position[0] == 0)  ) //negro ambos, entonces negro
			RGB_out = 3'b000;
		else if ((squareX_position[0] == 1)  && (squareY_position[0] == 1) ) //ambos blanco, entonces negro
			RGB_out = 3'b000;
		else // un es blanco y el otro es negro, entonces blanco
			RGB_out = 3'b111;
	end
	
	
endmodule
