`timescale 1ns / 1ps

module RAM_VGA # ( parameter DATA_WIDTH= 3, parameter WIDTH_SIZE=640, parameter HEIGHT_SIZE=480)
(
	input wire Clock,
	input wire iWriteEnable,
	input wire[24:0] iReadAddress,	
	input wire[24:0] iWriteAddress,
	input wire[DATA_WIDTH-1:0] iDataIn,
	output reg [DATA_WIDTH-1:0] oDataOut
);
	
reg [DATA_WIDTH-1:0] Ram [WIDTH_SIZE*HEIGHT_SIZE-1:0];

wire [DATA_WIDTH-1:0]temp_data;
//assign temp_data = Ram [141981];

always @(posedge Clock) begin
	if (iWriteEnable) begin
		Ram[iWriteAddress] <= iDataIn; 
	end
	oDataOut <= Ram[iReadAddress];
	
end
endmodule
