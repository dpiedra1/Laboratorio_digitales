`define ST_RESET  			0
`define ST_INIT_0 			1
`define TIME_40us 2000 
`define TIME_230ns 12
`define TIME_100us 5000 
`define TIME_4_1ms 205000 
`define TIME_1_64ms 82000 
`define TIME_40ns 2
`define TIME_1us 50





module VGA_Control(
	input  wire    Clock,
	input  wire    Reset,
	output reg     column_address,
	output reg     row_address,
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
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
		
	end
	`ST_INIT_0:
	begin
		//TODO
		
		
		
	end
	
	default:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
	end
	
	
	endcase
end



endmodule


module HSYNC_GEN(
	input  wire    Clock,
	input  wire    Reset,
	output reg     VGA_HSYNC
		
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
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
		
	end
	`ST_INIT_0:
	begin
		//TODO
		
		
		
	end
	
	default:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
	end
	
	
	endcase
end



endmodule

module VSYNC_GEN(
	input  wire    Clock,
	input  wire    Reset,
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
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
		
	end
	`ST_INIT_0:
	begin
		//TODO
		
		
		
	end
	
	default:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
	end
	
	
	endcase
end



endmodule


