`define ST_RESET  			0
`define ST_INIT_RAM     	1
`define ST_RAM_READY   		2

`define DATA_WIDTH         3
`define ADD_WIDTH          8 //se usa para row y column el mismo
`define ROW_SIZE           480
`define COLUMN_SIZE        640

module RAMWrapper(
input wire CLK,
input wire Reset,
input wire ReadyFlag,
input wire [2:0] RamRead,
output reg [2:0] wValue,
output reg RamReset
);


reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;
reg [ADD_WIDTH-1:0]row_counter;



//Logica del proximo estado
always @ (posedge Clock)
	begin
		if(Reset) begin
			rCurrentState <= `ST_RESET;
			rTimeCount    <= 32'b0;
			
		end
		else begin
			if(rTimeCountReset)
				rTimeCount <= 32'b0;
			else
				rTimeCount <= rTimeCount + 32'b1;
				
			rCurrentState <= rNextState;
		end
		
end






RAM_SINGLE_READ_PORT # (`DATA_WIDTH,`ADD_WIDTH,`ROW_SIZE,`COLUMN_SIZE) VideoMemory(
.Clock(CLK),
.iWriteEnable(),
.iReadRow(),
.iReadCol(),
.iWriteRow(),
.iWriteCol(),
.iDataIn(),
.oDataOut()
);

//Logica de estado actual y salida
always @ (*)
begin
	case (rCurrentState)
	
	`ST_RESET:
	begin
		rNextState=`ST_INIT_RAM;
		rTimeCountReset=1;
		row_counterReset = 1;
		
	end

	`ST_INIT_RAM:
	begin
		if (row_counter < `ROW_SIZE) begin
			rNextState=`ST_INIT_RAM;
			if(rTimeCount < `COLUMN_SIZE) begin
				rTimeCountReset = 0;
				row_counter = row_counter;
			end
			else begin
				rTimeCountReset =1;
				row_counter = row_counter + 1;
			end
		end	
		else begin
			rTimeCountReset =1;
			rNextState=`ST_RAM_READY;
		end
		
		
	end

	`ST_RAM_READY:
	begin
		
	
	end



	default:
	begin
		row_count = 0;
		column_count = 0;
		rNextState=`ST_V_PULSE_INIT;
		rTimeCountReset=1;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;

	end
		
	endcase

end

