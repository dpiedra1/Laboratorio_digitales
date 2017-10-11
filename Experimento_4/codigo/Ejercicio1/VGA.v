`define ST_RESET  			0
`define ST_V_PULSE_INIT 	1
`define ST_V_BP        		2
`define ST_H_DISP 	   	3
`define ST_H_DISP    		4
`define ST_H_TFP     		5
`define ST_H_PULSE   		6
`define ST_H_TBP     		7
`define ST_H_V_TFP   		8
`define ST_H_PULSE   		9


`define TIME_64us   1600 
`define TIME_928us  23200
`define TIME_25_6us 640 
`define TIME_640ns  16 
`define TIME_3_84us 96 
`define TIME_1_92us 48
`define TIME_320us  8000





module VGA_Control(
	input  wire    Clock,
	input  wire    Reset,
	output reg     [9:0]column_count,
	output reg     [8:0]row_count,
	output reg     VGA_HSYNC,
	output reg     VGA_VSYNC
	
);


reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;


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
		row_count = 0;
		column_count = 0;
		rNextState=`ST_V_PULSE_INIT;
		rTimeCountReset=1;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
	end
	`ST_V_PULSE_INIT:
	begin
		row_count = 0;
		column_count =0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 0;
		
		if (rTimeCount < `TIME_64us) begin
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
		row_count = 0;
		column_count =0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_928us) begin
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
		row_count <= row_count; //POSIBLE LATCH 
		column_count = rTimeCount;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_25_6us) begin
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
		row_count <= row_count; //POSIBLE LATCH 
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_640ns) begin
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
		row_count <= row_count + 1; //POSIBLE LATCH 
		column_count = 0;
		VGA_HSYNC = 0;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_3_84us) begin
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
		row_count <= row_count; //POSIBLE LATCH 
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_1_92us) begin
			rNextState=`ST_H_TBP;
			rTimeCountReset=0;
		end
		else begin
		rTimeCountReset=1;
			if(row_count < 10'd640) begin
				rNextState=`ST_H_DISP;
			end else begin
				rNextState=`ST_V_TFP;
			end
		end
		
		
	end

	`ST_V_TFP:
	begin
		row_count <= row_count; //POSIBLE LATCH 
		column_count <= column_count; //POSIBLE LATCH
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;
		
		if (rTimeCount < `TIME_320us) begin
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
		row_count = 0;  
		column_count = 0;
		VGA_HSYNC = 1;
		VGA_VSYNC = 0;
		
		if (rTimeCount < `TIME_64us) begin
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
		row_count = 0;
		column_count = 0;
		rNextState=`ST_V_PULSE_INIT;
		rTimeCountReset=1;
		VGA_HSYNC = 1;
		VGA_VSYNC = 1;

	end
	
	
	endcase
end



endmodule

