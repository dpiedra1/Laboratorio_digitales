`timescale 1ns / 1ps
`include "Defintions.v"
`include "Multipliers.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed

 
);
wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken, genResult;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg signed [31:0]   rResult;
wire signed [7:0]  wSourceAddr0,wSourceAddr1;
wire [7:0] wDestination;
wire [15:0] wIPInitialValue,wImmediateValue;
wire [31:0] wSourceData0,wSourceData1;


ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
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
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);




assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

wire [7:0]result_4bMult;
mult4bits_arrayMult mult4bits_arrayMult (
			.sourceA(wSourceData0[3:0]),
			.sourceB(wSourceData1[3:0]),
			.result(result_4bMult)			
		);

wire [31:0] result_16bMult;
mult16bits_arrayMult mult16bits_arrayMult (
		.sourceA(wSourceData0),
		.sourceB(wSourceData1),
		.result(result_16bMult)
		);


wire [31:0] resultadolut4;
wire [31:0] resultadolut16;

mullut4 lutde4(wSourceData0,wSourceData1,resultadolut4);
mullut16 lutde16(wSourceData0,wSourceData1,resultadolut16);
always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 - wSourceData0;
	end
	//-------------------------------------

	`MUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 * wSourceData0;
	end
	//-------------------------------------

	`IMUL_4:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult <= result_4bMult;
		
			
		
	end
	//-------------------------------------
	
	`IMUL_16:
	begin
	rFFLedEN     <= 1'b0;
	rBranchTaken <= 1'b0;
	rWriteEnable <= 1'b1;
	rResult      <= result_16bMult;
	end
	
	//-------------------------------------
	
	`IMUL2_4:
	begin
	rFFLedEN     <= 1'b0;
	rBranchTaken <= 1'b0;
	rWriteEnable <= 1'b1;
	rResult      <= resultadolut4;
	end
	
	//-------------------------------------
	
	`IMUL2_16:
	begin
	rFFLedEN     <= 1'b0;
	rBranchTaken <= 1'b0;
	rWriteEnable <= 1'b1;
	rResult      <= resultadolut16;
	end
	
	//-------------------------------------
	
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`SHTRIGHT:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData0>>8;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
	end
endmodule
