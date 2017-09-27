
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [3:0] SF_D,
 output wire LCD_E,
 output wire LCD_RS,
 output wire LCD_RW,
 output wire SF_CE0
 
);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;




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




assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

//Se instancia el modulo LCD_Control
reg send_chter;
reg [7:0] chter_to_send;
wire Idle_ready;

LCD_Control LCD_Control (
		.Clock(Clock), 
		.Reset(Reset), 
		.LCD_E(LCD_E),
		.LCD_RS(LCD_RS),
		.LCD_RW(LCD_RW),
		.SF_D(SF_D),
		.SF_CE0(SF_CE0),
		.send_chter(send_chter),
		.chter_to_send(chter_to_send),
		.Idle_ready(Idle_ready)
		
	);


always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
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
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LCD:
	begin
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		if (Idle_ready) begin
			chter_to_send <= wImmediateValue[7:0];
			send_chter <= 1'b1;
			rBranchTaken <= 1'b0;
		end
		else begin
			chter_to_send <= 8'd0;
			send_chter <= 1'b0;
			rBranchTaken <= 1'b1;
		end
		
	end
	//-------------------------------------
	default:
	begin
		send_chter <= 1'b0;
		chter_to_send <= 8'd0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
