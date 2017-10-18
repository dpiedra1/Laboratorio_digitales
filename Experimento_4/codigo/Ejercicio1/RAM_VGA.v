`timescale 1ns / 1ps

module RAM_SINGLE_READ_PORT # ( parameter DATA_WIDTH= 3, parameter ADDR_WIDTH=8, parameter ROW_SIZE=480, parameter COLUMN_SIZE=640)
(
	input wire Clock,
	input wire iWriteEnable,
	input wire[ADDR_WIDTH-1:0] iReadRow,	
	input wire[ADDR_WIDTH-1:0] iReadCol,
	input wire[ADDR_WIDTH-1:0] iWriteRow,
	input wire[ADDR_WIDTH-1:0] iWriteCol,
	input wire[DATA_WIDTH-1:0] iDataIn,
	output reg [DATA_WIDTH-1:0] oDataOut
);
	
reg [DATA_WIDTH-1:0] Ram [0:ROW_SIZE-1][0:COLUMN_SIZE-1];
always @(posedge Clock) begin
	if (iWriteEnable) begin
		Ram[iWriteRow][iWriteCol] <= iDataIn; 
		oDataOut <= Ram[iReadRow][iReadCol];
	end
end
endmodule
