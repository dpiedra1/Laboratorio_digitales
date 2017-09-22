`define ST_RESET  			0
`define ST_INIT_0 			1
`define ST_INIT_1 			2
`define ST_INIT_2 			3
`define ST_INIT_3 			4
`define ST_INIT_4 			5
`define ST_DC_0A  			6
`define ST_DC_0B  			7
`define ST_DC_1A  			8
`define ST_DC_1B  			9
`define ST_DC_2A  			10
`define ST_DC_2B  			11
`define ST_DC_3A  			12
`define ST_DC_3B  			13
`define ST_SET_RAM_ADDSS_0 14
`define ST_SET_RAM_ADDSS_1 15
`define ST_SEND_DATA_A     16
`define ST_SEND_DATA_B     17
`define ST_IDLE				18
`define TIME_40us 2000 //valor correcto 2000, como es muy grande se cambio,100
`define TIME_230ns 12
`define TIME_100us 5000 //valor correcto 5000, como es muy grande se cambio,200
`define TIME_4_1ms 205000 //valor correcto 205000, como es muy grande se cambio,300
`define TIME_1_64ms 82000 //valor correcto 82000, como es muy grande se cambio,400
`define TIME_40ns 2
`define TIME_1us 50





module LCD_Control(
	input  wire     Clock,
	input  wire     Reset,
	output reg     LCD_E,
	output reg      LCD_RS,
	output wire     LCD_RW,
	output reg[3:0] SF_D,
	output wire     SF_CE0,
	output reg		 Idle_ready, //indica cuando esta en el estado idle (listo para enviar)
	input wire		 send_chter, //cuando se desea enviar el caracter
	input wire[7:0] chter_to_send	//los 8 bits del caracter que se desea enviar	 
	
);

assign LCD_RW = 0;
assign SF_CE0=1;
reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;
reg [1:0] init0counter;
reg init3counter;
reg enable_input_chter; //Indica cuando borrar el contenido del flip flop
							  //que almacena los datos de entrada
wire [7:0] chter_to_send_ff;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) input_chter
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(enable_input_chter),
	.D(chter_to_send),
	.Q(chter_to_send_ff)
);

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
		init0counter=0;
		init3counter=0;
		Idle_ready=0;
		enable_input_chter=0;
	end
	`ST_INIT_0:
	begin
		SF_D=4'b11;
		LCD_RS=1;
		rTimeCountReset=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		init0counter[0]=init0counter[0]?1:0;
		init0counter[1]=init0counter[1]?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(init0counter==0) begin
					rNextState=`ST_INIT_1;
					init0counter=init0counter+1;
					rTimeCountReset=1;
				end else if(init0counter==1) begin
					rNextState=`ST_INIT_2;
					init0counter=init0counter+1;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_INIT_3;
					init0counter=init0counter+1;
					rTimeCountReset=1;
				end
			end else begin
				rNextState=`ST_INIT_0;
			end
		end else begin
			rNextState=`ST_INIT_0;
		end
	end
	`ST_INIT_1:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rTimeCountReset=0;
		init0counter[0]=init0counter[0]?1:0;
		init0counter[1]=init0counter[1]?1:0;
		Idle_ready=0;
		init3counter=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_4_1ms) begin
			rNextState=`ST_INIT_0;
			rTimeCountReset=1;
		end else begin
			rNextState=`ST_INIT_1;
		end
	end
	`ST_INIT_2:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rTimeCountReset=0;
		init0counter[0]=init0counter[0]?1:0;
		init0counter[1]=init0counter[1]?1:0;
		Idle_ready=0;
		init3counter=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_100us) begin
			rNextState=`ST_INIT_0;
			rTimeCountReset=1;
		end else begin
			rNextState=`ST_INIT_2;
		end
	end
	
	//Apartir de aqui ya no se usa el init0counter
	
	`ST_INIT_3:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rTimeCountReset=0;
		init0counter=0;
		init0counter = init0counter;
		Idle_ready=0;
		enable_input_chter=0;
		if (init3counter)
			init3counter =1;
		else
			init3counter =0;
		if(rTimeCount>`TIME_40us) begin
			if(init3counter==0)begin
				rNextState=`ST_INIT_4;
				init3counter = 1;
				rTimeCountReset=1;
			end else begin
				rNextState=`ST_DC_0A;
				rTimeCountReset=1;
				init3counter=0;
			end
		end else begin
			rNextState=`ST_INIT_3;
			//init3counter= init3counter; //cambio aqui
			
		end
	end
	`ST_INIT_4: 
	begin
		LCD_RS=1;
		SF_D=4'b10;
		rTimeCountReset=0;
		init0counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if (init3counter)
			init3counter =1;
		else
			init3counter =0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				rNextState=`ST_INIT_3;
				rTimeCountReset=1;
			end else begin
				rNextState=`ST_INIT_4;
			end
		end else begin
			rNextState=`ST_INIT_4;
		end
	end
	`ST_DC_0A:
	begin
		LCD_RS=0;
		SF_D=4'b10;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_DC_0B;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_0A;
				end
			end else begin
				rNextState=`ST_DC_0A;
			end
		end else begin
			rNextState=`ST_DC_0A;
		end
	end
	`ST_DC_0B:
	begin
		LCD_RS=0;
		SF_D=4'b1000;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_40us)) begin
					rNextState=`ST_DC_1A;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_0B;
				end 
			end else begin
				rNextState=`ST_DC_0B;
			end
		end else begin
			rNextState=`ST_DC_0B;
		end
	end
	`ST_DC_1A:
	begin
		LCD_RS=0;
		SF_D=4'b0;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_DC_1B;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_1A;
				end 
			end else begin
				rNextState=`ST_DC_1A;
			end 
		end else begin
			rNextState=`ST_DC_1A;
		end
	end
	`ST_DC_1B:
	begin
		LCD_RS=0;
		SF_D=4'b110;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_40us)) begin
					rNextState=`ST_DC_2A;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_1B;
				end 
			end else begin
				rNextState=`ST_DC_1B;
			end 
		end else begin
			rNextState=`ST_DC_1B;
		end
	end
	`ST_DC_2A:
	begin
		LCD_RS=0;
		SF_D=4'b0;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_DC_2B;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_2A;
				end 
			end else begin
				rNextState=`ST_DC_2A;
			end 
		end else begin
			rNextState=`ST_DC_2A;
		end
	end
	`ST_DC_2B:
	begin
		LCD_RS=0;
		SF_D=4'b1100;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_40us)) begin
					rNextState=`ST_DC_3A;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_2B;
				end 
			end else begin
				rNextState=`ST_DC_2B;
			end 
		end else begin
			rNextState=`ST_DC_2B;
		end
	end
	`ST_DC_3A:
	begin
		LCD_RS=0;
		SF_D=4'b0;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_DC_3B;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_3A;
				end 
			end else begin
				rNextState=`ST_DC_3A;
			end
		end else begin
			rNextState=`ST_DC_3A;
		end
	end
	`ST_DC_3B:
	begin
		LCD_RS=0;
		SF_D=4'b1;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1_64ms)) begin
					rNextState=`ST_SET_RAM_ADDSS_0;//Cambiar por ST_SET_RAM_ADDSS_0
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_DC_3B;
				end 
			end else begin
				rNextState=`ST_DC_3B;
			end
		end else begin
			rNextState=`ST_DC_3B;
		end
	end
	
	`ST_SET_RAM_ADDSS_0:
	begin
		LCD_RS=0;
		SF_D=4'h8;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_SET_RAM_ADDSS_1;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_SET_RAM_ADDSS_0;
				end
			end else begin
				rNextState=`ST_SET_RAM_ADDSS_0;
			end
		end else begin
			rNextState=`ST_SET_RAM_ADDSS_0;
		end
	
	end
	
	`ST_SET_RAM_ADDSS_1:
	begin
		LCD_RS=0;
		SF_D=4'h0;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_40us)) begin
					rNextState=`ST_IDLE;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_SET_RAM_ADDSS_1;
				end
			end else begin
				rNextState=`ST_SET_RAM_ADDSS_1;
			end
		end else begin
			rNextState=`ST_SET_RAM_ADDSS_1;
		end
	
	end
	
	`ST_SEND_DATA_A:
	begin
		LCD_RS=1;
		SF_D= chter_to_send_ff[7:4];
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_1us)) begin
					rNextState=`ST_SEND_DATA_B;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_SEND_DATA_A;
				end
			end else begin
				rNextState=`ST_SEND_DATA_A;
			end
		end else begin
			rNextState=`ST_SEND_DATA_A;
		end
	
	end
	
	
	`ST_SEND_DATA_B:
	begin
		LCD_RS=1;
		SF_D= chter_to_send_ff[3:0];
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		LCD_E = LCD_E?1:0;
		Idle_ready=0;
		enable_input_chter=0;
		if(rTimeCount>`TIME_40ns) begin
			LCD_E=1;
			if(rTimeCount>(`TIME_40ns+`TIME_230ns)) begin
				LCD_E=0;
				if(rTimeCount>(`TIME_40ns+`TIME_230ns+`TIME_40us)) begin
					rNextState=`ST_IDLE;
					rTimeCountReset=1;
				end else begin
					rNextState=`ST_SEND_DATA_B;
				end
			end else begin
				rNextState=`ST_SEND_DATA_B;
			end
		end else begin
			rNextState=`ST_SEND_DATA_B;
		end
	
	end
	
	`ST_IDLE:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_IDLE;
		rTimeCountReset=0;
		init0counter=0;
		init3counter=0;
		Idle_ready=1;
				
		if (send_chter) begin
			enable_input_chter=1;
			rNextState=`ST_SEND_DATA_A;
		end
		else begin
			enable_input_chter =0;
			rNextState=`ST_IDLE;
		end
		
	end
	
	default:
	begin
		SF_D=4'b0;
		LCD_E=0;
		LCD_RS=1;
		rNextState=`ST_INIT_0;
		rTimeCountReset=1;
		init0counter=0;
		init3counter=0;
		Idle_ready=0;
		enable_input_chter =0;
	end
	
	
	endcase
end



endmodule