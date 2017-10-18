//Tamano de la RAM
`define DATA_WIDTH         3
`define ADDR_WIDTH          8 //se usa para row y column el mismo
`define ROW_SIZE           100
`define COLUMN_SIZE        100



module RAMWrapper(
input wire CLK,
input wire iWriteEnable,
input wire [`ADDR_WIDTH-1:0]iReadCol,
input wire [`ADDR_WIDTH-1:0]iReadRow,
input wire [`ADDR_WIDTH-1:0]iWriteCol,
input wire [`ADDR_WIDTH-1:0]iWriteRow,
input wire [2:0] RGB_in,
output reg [2:0] RGB_out
);

reg iWriteEnable_RAM;
reg[`ADDR_WIDTH-1:0] iReadRow_RAM;	
reg [`ADDR_WIDTH-1:0] iReadCol_RAM;
reg [`ADDR_WIDTH-1:0] iWriteRow_RAM;
reg [`ADDR_WIDTH-1:0] iWriteCol_RAM;
reg [`DATA_WIDTH-1:0] iDataIn_RAM;
wire [`DATA_WIDTH-1:0] oDataOut_RAM;




always @ (*) begin

	//Para leer
	if ((iReadRow < 240-`ROW_SIZE/2   ) || (iReadRow > 240 + `ROW_SIZE/2  )  || (iReadCol < 320 - `COLUMN_SIZE ) || (iReadCol > 320 + `COLUMN_SIZE) ) begin
		iReadRow_RAM = 0;
		iReadCol_RAM = 0;
		RGB_out = 3'b0;
		
	end
	else begin
		iReadRow_RAM = iReadRow - 240;
		iReadCol_RAM = iReadCol - 320;
		RGB_out = oDataOut_RAM;
	end
	
	//Para escribir
	if ((iWriteRow < 240-`ROW_SIZE/2   ) || (iWriteRow > 240 + `ROW_SIZE/2  )  || (iWriteCol < 320 - `COLUMN_SIZE ) || (iWriteCol > 320 + `COLUMN_SIZE) ) begin
		iWriteEnable_RAM = 0;
		iWriteRow_RAM  = 0;
		iWriteCol_RAM = 0;
		iDataIn_RAM = 3'b0;
	end
	else begin
		if (iWriteEnable) begin
			iWriteEnable_RAM = 1;
		end
		else begin
			iWriteEnable_RAM = 0;
		end
		iWriteRow_RAM  = iWriteRow -240;
		iWriteCol_RAM = iWriteCol -320;
		iDataIn_RAM = RGB_in;
	end	

end



RAM_SINGLE_READ_PORT # (`DATA_WIDTH,`ADDR_WIDTH,`ROW_SIZE,`COLUMN_SIZE) VideoMemory(
.Clock(CLK),
.iWriteEnable(iWriteEnable_RAM),
.iReadRow(iReadRow_RAM),
.iReadCol(iReadCol_RAM),
.iWriteRow(iWriteRow_RAM),
.iWriteCol(iWriteCol_RAM),
.iDataIn(iData_In_RAM),
.oDataOut(oDataOut_RAM)
);





endmodule
