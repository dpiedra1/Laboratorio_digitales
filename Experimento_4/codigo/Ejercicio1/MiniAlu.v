`timescale 1ns / 1ps
`include "Defintions.v"

`define DATA_WIDTH         3
`define ADD_WIDTH          8 //se usa para row y column el mismo


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire VGA_RED,
 output wire VGA_GREEN,
 output wire VGA_BLUE,
 output wire VGA_HSYNC,
 output wire VGA_VSYNC
 
);

wire Clock_25;

DIV_POSEDGE_ASYNCRONOUS_RESET # ( 8 ) FF_CLOCK25 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.Q(Clock_25)
);


wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;

reg rWriteEnable_RAM_VGA; //TODO (falta agregarlo en la instruccion write)

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);


wire [`ADD_WIDTH-1: 0] iReadRow;
wire [`ADD_WIDTH-1: 0] iReadCol;
reg [`ADD_WIDTH-1: 0] iWriteRow;
reg [`ADD_WIDTH-1: 0] iWriteCol;
reg [`DATA_WIDTH -1: 0] RGB_to_write;



RAMWrapper RAMWrapper(
.CLK(Clock_25),
.iWriteEnable(rWriteEnable_RAM_VGA),
.iReadCol(iReadCol),
.iReadRow(iReadRow),
.iWriteCol(iWriteCol),
.iWriteRow(iWriteRow),
.RGB_in(RGB_to_write),
.RGB_out({VGA_RED,VGA_GREEN,VGA_BLUE})
);

VGA_Control VGA_Control(
	.Clock (Clock_25),
	.Reset (Reset),
	.column_count(iReadCol),
	.row_count(iReadRow),
	.VGA_HSYNC(VGA_HSYNC),
	.VGA_VSYNC(VGA_VSYNC)
	
);




RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock_25        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock_25                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1 
(
	.Clock(Clock_25),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock_25),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock_25),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock_25),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);



assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rWriteEnable_RAM_VGA <=0;
	end
	//-------------------------------------
	`ADD:
	begin
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
		rWriteEnable_RAM_VGA <=0;
	end
	//-------------------------------------
	`STO:
	begin
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
		rWriteEnable_RAM_VGA <=0;
	end
	//-------------------------------------
	`BLE:
	begin
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rWriteEnable_RAM_VGA <=0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rWriteEnable_RAM_VGA <=0;
	end
	//-------------------------------------	
	//-------------------------------------
	default:
	begin
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rWriteEnable_RAM_VGA <=0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
