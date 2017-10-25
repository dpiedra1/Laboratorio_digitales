`define ST_RESET  			0
`define ST_V_PULSE_INIT 	1
`define ST_V_BP        		2
`define ST_H_DISP 	   	3
`define ST_H_TFP     		4
`define ST_H_PULSE   		5
`define ST_H_TBP     		6
`define ST_V_TFP   			7
`define ST_V_PULSE   		8


`define TIME_64us   16  //Valor correcto 1600
`define TIME_928us  23 //Valor correcto 23200
`define TIME_25_6us 64   //Valor correcto 640
`define TIME_640ns  16    //Valor correcto 16
`define TIME_3_84us 96    //Valor correcto 96
`define TIME_1_92us 48    //Valor correcto 48
`define TIME_320us  80  //Valor correcto 8000
`define D_480		  480




module VGA_Control(
	input  wire    Clock,
	input  wire    Reset,
	output reg     [9:0]column_count,
	output wire     [9:0]row_count,
	output reg     VGA_HSYNC,
	output reg     VGA_VSYNC
	
);


reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;


UPCOUNTER_POSEDGE_ASYRET #(10) row_counter 
(
.Clock(   VGA_HSYNC            ), 
.Reset(   !VGA_VSYNC           ),
.Q(       row_count            )
);

wire [9:0] temp_row_count;
assign temp_row_count = row_count;

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


//Logica de estado actual y salida
always @ (*)
begin
	case (rCurrentState)
	
	`ST_RESET:
	begin
		column_count = 0;
		rNextState=`ST_V_PULSE_INIT;
		rTimeCountReset=1;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
	end
	`ST_V_PULSE_INIT:
	begin
		column_count =0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 0;
		
		if (rTimeCount < `TIME_64us-1) begin
			rNextState=`ST_V_PULSE_INIT;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_V_BP;
			rTimeCountReset=1;
		end
		
		
	end
	

	`ST_V_BP:
	begin
		column_count =0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_928us-1) begin
			rNextState=`ST_V_BP;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_H_DISP;
			rTimeCountReset=1;
		end
		
		
	end

	`ST_H_DISP:
	begin
		column_count = rTimeCount;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_25_6us-1) begin
			rNextState=`ST_H_DISP;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_H_TFP;
			rTimeCountReset=1;
		end
		
		
	end


	`ST_H_TFP:
	begin
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_640ns-1) begin
			rNextState=`ST_H_TFP;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_H_PULSE;
			rTimeCountReset=1;
		end
		
		
	end


	`ST_H_PULSE:
	begin
		
		column_count = 0;
		VGA_HSYNC = 0;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_3_84us-1) begin
			rNextState=`ST_H_PULSE;
			rTimeCountReset=0;
			 
		end
		else begin
			rNextState=`ST_H_TBP;
			rTimeCountReset=1;
			
		end
		
		
	end


	`ST_H_TBP:
	begin
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_1_92us-1) begin
			rNextState=`ST_H_TBP;
			rTimeCountReset=0;
		end
		else begin
		rTimeCountReset=1;
			if(temp_row_count < `D_480-1) begin
				rNextState=`ST_H_DISP;
			end else begin
				rNextState=`ST_V_TFP;
				//rNextState=`ST_H_DISP;
			end
		end
		
		
	end

	`ST_V_TFP:
	begin
		column_count = 0; //POSIBLE LATCH ***Cambio aqui
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_320us-1) begin
			rNextState=`ST_V_TFP;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_V_PULSE;
			rTimeCountReset=1;
		end
		
		
	end


	`ST_V_PULSE:
	begin
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 0;
		
		if (rTimeCount < `TIME_64us-1) begin
			rNextState=`ST_V_PULSE;
			rTimeCountReset=0;
		end
		else begin
			rNextState=`ST_V_BP;
			rTimeCountReset=1;
		end
		
		
	end



	default:
	begin
		column_count = 0;
		rNextState=`ST_V_PULSE_INIT;
		rTimeCountReset=1;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;

	end
	
	
	endcase
end



endmodule

