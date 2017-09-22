
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [3:0] SF_D,
 output wire LCD_E,
 output wire LCD_RS,
 output wire LCD_RW
 
);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;



//Wires necesarios para conectar la maquina de estados
wire oLCD_Enabled, oLCD_RegisterSelect, oLCD_ReadWrite;
wire [3:0] oLCD_Data;



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


reg rFF_SF_D_EN, rFF_LCD_E_EN,rFF_LCD_RS_EN, rFF_LCD_RW_EN;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FF_SF_D
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFF_SF_D_EN ),
	.D( oLCD_Data ),
	.Q( SF_D    )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FF_LCD_E
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFF_LCD_E_EN ),
	.D( oLCD_Enabled ),
	.Q( LCD_E    )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FF_LCD_RS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFF_LCD_RS_EN ),
	.D( oLCD_RegisterSelect ),
	.Q( LCD_RS    )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FF_LCD_RW
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFF_LCD_RW_EN ),
	.D( oLCD_ReadWrite ),
	.Q( LCD_RW    )
);


assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
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
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	default:
	begin
		rFF_SF_D_EN     <= 1'b0;
		rFF_LCD_E_EN    <= 1'b0;
		rFF_LCD_RS_EN   <= 1'b0;
		rFF_LCD_RW_EN   <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
