`include "VGA_DEFINES.v"


module RAMWrapper(
input wire CLK,
input wire Reset,
input wire iWriteEnable,
input wire [10:0]iReadCol,
input wire [9:0]iReadRow,
input wire [10:0]iWriteCol,
input wire [9:0]iWriteRow,
input wire [2:0] RGB_in,
output reg [2:0] RGB_out
);

	wire [24:0] address_initializer;
	wire [2:0] RGB_initializer;
	wire writeEnable_initializer;
	wire RAM_ready_initializer;
	RAM_INITIALIZER RAM_INITIALIZER (
		.Clock(CLK),
		.Reset(Reset),
		.address(address_initializer),
		.RGB(RGB_initializer),
		.writeEnable(writeEnable_initializer),
		.RAM_ready(RAM_ready_initializer)
	);

	reg iWriteEnable_RAM;
	reg [24:0]iWrite_RAM;
	reg [24:0]iReadAddress_RAM;
	reg [2:0] iDataIn_RAM;
	wire [2:0] DataOut_RAM;

		//Se instancia la RAM
	RAM_VGA # (3,`WIDTH_SIZE_RAM,`HEIGHT_SIZE_RAM) VideoMemory(
		.Clock(CLK),
		.iWriteEnable(writeEnable_initializer),
		.iReadAddress(iReadAddress_RAM),
		.iWriteAddress(address_initializer),
		.iDataIn(RGB_initializer),
		.oDataOut(DataOut_RAM)
	);





always @ (posedge CLK) begin
	//Imprime el marco negro
	if ((iReadCol <= (`WIDTH_SIZE_RES/2 - `WIDTH_SIZE_RAM/2)) || (iReadCol >= (`WIDTH_SIZE_RES/2 + `WIDTH_SIZE_RAM/2)) 
		|| (iReadRow <= (`HEIGHT_SIZE_RES/2 -`HEIGHT_SIZE_RAM/2) ) ||  (iReadRow >= (`HEIGHT_SIZE_RES/2 +`HEIGHT_SIZE_RAM/2) ) )begin
		RGB_out <= 3'b000;
		iReadAddress_RAM <= `WIDTH_SIZE_RAM*(iReadRow -(`HEIGHT_SIZE_RES/2-`HEIGHT_SIZE_RAM/2)) 
										+ iReadCol-(`WIDTH_SIZE_RES/2-`WIDTH_SIZE_RAM/2)+2; //Debido a que la RAM atrasa la salida un ciclo y el wrapper tambien entonces se pide el valor con dos direcciones de atraso, asi cuando sea el inicio del cuadro de RAM el valor ya este en RAM
	end
	else begin
		//Imprime cuando la direccion esta dentro de la RAM y ademas esta lista
		if (RAM_ready_initializer) begin
			//x' = iReadCol-(`WIDTH_SIZE_RES/2-`WIDTH_SIZE_RAM/2)
			//y' = iReadRow - (`HEIGHT_SIZE_RES/2-`HEIGHT_SIZE_RAM/2)
			iReadAddress_RAM <= `WIDTH_SIZE_RAM*(iReadRow -(`HEIGHT_SIZE_RES/2-`HEIGHT_SIZE_RAM/2)) 
										+ iReadCol-(`WIDTH_SIZE_RES/2-`WIDTH_SIZE_RAM/2);
			RGB_out <= DataOut_RAM;
		end
		//Imprime cuando no esta listo
		else begin
			RGB_out <= 3'b110; //amarillo
			iReadAddress_RAM <= 0;
		end
	end
	
end

endmodule





`define ST_RESET    0
`define ST_WRITING  1
`define ST_READY    2



module RAM_INITIALIZER(
	input wire Clock,
	input wire Reset,
	output wire [24:0] address,
	output reg [2:0] RGB,
	output reg writeEnable,
	output reg RAM_ready
);
	
	reg [7:0] rCurrentState,rNextState;
	reg [24:0] counter;
	reg reset_counter;
	
	assign address = counter;
	

	//Logica del proximo estado
always @ (posedge Clock or posedge Reset)
	begin
		if(Reset) begin
			rCurrentState <= `ST_RESET;
			counter <= 25'd0;
						
		end
		else begin
			if(reset_counter)
				counter <= 25'd0;
			else
				counter <= counter + 25'b1;
			
			rCurrentState <= rNextState;
		end
	end



	//Logica de estado actual y salida
	always @ (*)
begin
	case (rCurrentState)
	
	`ST_RESET:
	begin
		reset_counter =1;
		RGB            = 3'b000;
		writeEnable    = 1'b0;
		RAM_ready      = 1'b0;
		rNextState     = `ST_WRITING;
		
	end
	
	`ST_WRITING:
	begin
		writeEnable    = 1'b1;
		RAM_ready      = 1'b0;
		if (counter < `WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM-1) begin
			rNextState = `ST_WRITING;
			reset_counter = 0;
			if (counter < (`WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM)/4-1 )
				RGB           = 3'b010; //verde
			else if ( (counter >= (`WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM)/4-1) && counter < (`WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM)/2-1 )
				RGB           = 3'b100; //rojo
			else if ( (counter >= (`WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM)/2-1) && counter < (`WIDTH_SIZE_RAM*`HEIGHT_SIZE_RAM)*3/4-1 )
				RGB           = 3'b101; //magenta
			else
				RGB           = 3'b001; //azul
				
			
		end
		else begin
			rNextState    = `ST_READY;
			reset_counter = 1;
			RGB           = 3'b000;
			
		end
		
		
	end
	
	
	`ST_READY:
	begin
		
		reset_counter = 1;
		RGB            = 3'b000;
		writeEnable    = 1'b0;
		RAM_ready      = 1'b1;
		rNextState     = `ST_READY;

	
	end



	default:
	begin
		reset_counter = 0;
		RGB            = 3'b000;
		writeEnable    = 1'b0;
		RAM_ready      = 1'b0;
		rNextState     = `ST_RESET;


	end
	
	
	endcase
end





endmodule 
