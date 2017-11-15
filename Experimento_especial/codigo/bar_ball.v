`include "VGA_DEFINES.v"
`define bar_width 120
`define bar_height 10
`define bar_color 3'b111  //blanca
`define bar_pixel_change 20 //numero de pixels que se desplaza la barra por cada vez que se presiona un boton

`define ball_size 20  //Se ve como un cuadrado
`define ball_color 3'b100
`define ball_time_change 125000 //cada cuantos ciclos la bola deberia cambiar (5ms)

module bar_ball (
	input wire [10:0] iReadCol,
	input wire [9:0]  iReadRow,
	input wire Clock, 			//clock de 25MHz
	input wire Reset,
	input wire [4:0] mAccion,
	input wire bandera,
	output wire [2:0]  RGB_out,
	output reg display_bar_or_ball
	);
	
	//Posicion del centro de las barras en el eje x
	reg signed [10:0] bar0_xPosition;
	reg signed [10:0] bar1_xPosition;
	
	//Posicion del centro de la bola
	reg signed [10:0] ball_xPosition;
	reg signed [9:0] ball_yPosition;
	
	//time counter
	reg [31:0]time_counter;
	
	//Registro para almacenar la direccion en la que deberia ir la bola
	reg [3:0] ball_direction;
	
	//Registro para definir cuando empezar el juego
	reg game_running = 1;
	
	//Registro para saber cuando se golpeo una barra o borde lateral
	reg hit_bar_or_border;
	
	assign RGB_out = `bar_color;
	
	
	//barra 1, la de arriba
	/*always @ (posedge bandera or posedge Reset) begin
		if (Reset) begin
			bar1_xPosition <= `WIDTH_SIZE_RES/2;
			bar0_xPosition <= `WIDTH_SIZE_RES/2;
		end
		else if (button_right) begin
			//caso en el que no esta cerca del borde   
			if (bar0_xPosition + `bar_pixel_change + `bar_width/2 < `WIDTH_SIZE_RES )begin 
				bar0_xPosition <= bar0_xPosition + `bar_pixel_change;
			
			//caso en el que si esta cerca del borde
			end else begin
				bar0_xPosition <= `WIDTH_SIZE_RES - `bar_width/2;
			end
		
		end else if (button_left) begin // se presiono el boton de la derecha
			
		
		//caso en el que no esta cerca del borde   
			if (bar0_xPosition - `bar_pixel_change - `bar_width/2 > 0 )begin 
				bar0_xPosition <= bar0_xPosition - `bar_pixel_change;
			//caso en el que si esta cerca del borde
			end else begin
				bar0_xPosition <=`bar_width/2;
			end
		end
		else if (button_down) begin
			
			//caso en el que no esta cerca del borde   
			if (bar1_xPosition + `bar_pixel_change + `bar_width/2 < `WIDTH_SIZE_RES )begin 
				bar1_xPosition <= bar1_xPosition + `bar_pixel_change;
			
			//caso en el que si esta cerca del borde
			end else begin
				bar1_xPosition <= `WIDTH_SIZE_RES - `bar_width/2;
			end
		end else if (button_up) begin // se presiono el boton de la derecha
		//caso en el que no esta cerca del borde   
			if (bar1_xPosition - `bar_pixel_change - `bar_width/2 > 0 )begin 
				bar1_xPosition <= bar1_xPosition - `bar_pixel_change;
			
			//caso en el que si esta cerca del borde
			end else begin
				bar1_xPosition <=`bar_width/2;
			end
		
			
		end
		
		
	end
	*/
	
	/*always @(posedge bandera or posedge Reset) begin
		if(Reset) begin
			bar0_xPosition<=`WIDTH_SIZE_RES/2;
			bar1_xPosition<=`WIDTH_SIZE_RES/2;
	
		end else begin
			case (mAccion)
				5'b10: begin
					if (bar0_xPosition - `bar_pixel_change - `bar_width/2 > 0)begin 
						bar0_xPosition <= bar0_xPosition - `bar_pixel_change;
					//caso en el que si esta cerca del borde
					end else begin
						bar0_xPosition <=`bar_width/2;
					end
				end
				
				5'b100: begin
					if (bar0_xPosition + `bar_pixel_change + `bar_width/2 < `WIDTH_SIZE_RES )begin 
						bar0_xPosition <= bar0_xPosition + `bar_pixel_change;
					//caso en el que si esta cerca del borde
					end else begin
						bar0_xPosition <= `WIDTH_SIZE_RES - `bar_width/2;
					end
				end
				
				5'b1000: begin
					if (bar1_xPosition - `bar_pixel_change - `bar_width/2 > 0 )begin 
						bar1_xPosition <= bar1_xPosition - `bar_pixel_change;	
					//caso en el que si esta cerca del borde
					end else begin
						bar1_xPosition <=`bar_width/2;
					end
				end
				
				5'b10000: begin
					//caso en el que no esta cerca del borde   
				if (bar1_xPosition + `bar_pixel_change + `bar_width/2 < `WIDTH_SIZE_RES )begin 
					bar1_xPosition <= bar1_xPosition + `bar_pixel_change;
				
				//caso en el que si esta cerca del borde
				end else begin
					bar1_xPosition <= `WIDTH_SIZE_RES - `bar_width/2;
				end
				end
			endcase
		end
	end*/
	
	
	//barra 1
	always @ (posedge bandera or posedge Reset) begin
		if(Reset) begin
			bar1_xPosition = `WIDTH_SIZE_RES/2;
		end
		else begin 
			if ( mAccion[1] ) begin
				bar1_xPosition = bar1_xPosition - `bar_pixel_change;
			end
			else if ( mAccion[2] ) begin
				bar1_xPosition = bar1_xPosition + `bar_pixel_change;
			end
		end
			
		
	end
	
	
	//barra 0
	always @ (posedge bandera or posedge Reset) begin
		if(Reset) begin
			bar0_xPosition = `WIDTH_SIZE_RES/2;
		end
		else begin 
			if ( mAccion[4]) begin
				bar0_xPosition = bar0_xPosition - `bar_pixel_change;
			end
			else if ( mAccion[3] ) begin
				bar0_xPosition = bar0_xPosition + `bar_pixel_change;
			end
		end
			
		
	end
	
	
	
	
	always @ (posedge Clock or posedge Reset) begin
		if (Reset) begin
			ball_xPosition <= `WIDTH_SIZE_RES/2;
			ball_yPosition <= `HEIGHT_SIZE_RES/2;
			time_counter <= 0;
			ball_direction <= 3'b000;
			hit_bar_or_border <= 0;
		end else if ((time_counter < `ball_time_change ) && (game_running)) begin
			time_counter <= time_counter +1;
		end else begin
			time_counter <= 0;
			//Aqui se encuentra el movimiento de la bola
			if (game_running) begin
				
				//Si la bola pego en los bordes laterales, cambia de direccion
				if (((ball_xPosition + `ball_size/2 >= `WIDTH_SIZE_RES-1) || 
					 (ball_xPosition - `ball_size/2 <= 0)) && (!hit_bar_or_border)) begin
					hit_bar_or_border <= 1;
					case (ball_direction)
						3'b000: begin
							ball_direction <= 3'b011;
							ball_xPosition <= ball_xPosition -3;
							ball_yPosition <= ball_yPosition +1;
						end
						3'b001: begin
							ball_direction <= 3'b010;
							ball_xPosition <= ball_xPosition +3;
							ball_yPosition <= ball_yPosition +1;
						end
						3'b010: begin
							ball_direction <= 3'b001;
							ball_xPosition <= ball_xPosition -3;
							ball_yPosition <= ball_yPosition +1; 
						end
						3'b011: begin
							ball_direction <= 3'b000;
							ball_xPosition <= ball_xPosition +3;
							ball_yPosition <= ball_yPosition +1; 
						end
						3'b100: begin
							ball_direction <= 3'b111;
							ball_xPosition <= ball_xPosition -3;
							ball_yPosition <= ball_yPosition -1;
						end
						3'b101: begin
							ball_direction <= 3'b110;
							ball_xPosition <= ball_xPosition +2;
							ball_yPosition <= ball_yPosition -1; 
						end
						3'b110: begin
							ball_direction <= 3'b101;
							ball_xPosition <= ball_xPosition -3;
							ball_yPosition <= ball_yPosition -1; 
						end
						3'b111: begin
							ball_direction <= 3'b100;
							ball_xPosition <= ball_xPosition +3;
							ball_yPosition <= ball_yPosition -1;
						end	
					endcase
					
				end
				
				//Si pega la barra 1
				else if (((ball_xPosition+`ball_size/2 <= bar1_xPosition + `bar_width/2 + `ball_size) && 
							(ball_xPosition-`ball_size/2 >= bar1_xPosition - `bar_width/2 - `ball_size)) &&
							 (ball_yPosition - `ball_size/2 == `bar_height) && (!hit_bar_or_border) ) begin
					hit_bar_or_border <= 1;
					
				//derecha
					if(ball_xPosition > (bar1_xPosition + `bar_width/6)) begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b0110;
							4'b0001:
								ball_direction <= 4'b0110;
							4'b0010:
								ball_direction <= 4'b0100;
							4'b0011:
								ball_direction <= 4'b0100;
							4'b0100:
								ball_direction <= 4'b0010;
							4'b0101:
								ball_direction <= 4'b0010;
							4'b0110:
								ball_direction <= 4'b0000;
							4'b0111:
								ball_direction <= 4'b0000;
							4'b1111:
								ball_direction <= 4'b0010;
							4'b1000:
								ball_direction <= 4'b0010;
						endcase
					
					//izquierda
					end else if (ball_xPosition < (bar1_xPosition - `bar_width/6) ) begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b0111;
							4'b0001:
								ball_direction <= 4'b0111;
							4'b0010:
								ball_direction <= 4'b0101;
							4'b0011:
								ball_direction <= 4'b0101;
							4'b0100:
								ball_direction <= 4'b0011;
							4'b0101:
								ball_direction <= 4'b0011;
							4'b0110:
								ball_direction <= 4'b0001;
							4'b0111:
								ball_direction <= 4'b0001;
							4'b1111:
								ball_direction <= 4'b0011;
							4'b1000:
								ball_direction <= 4'b0011;
						endcase
					
					end
					//centro
					else begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b1000;
							4'b0001:
								ball_direction <= 4'b1000;
							4'b0010:
								ball_direction <= 4'b1000;
							4'b0011:
								ball_direction <= 4'b1000;
							4'b0100:
								ball_direction <= 4'b1000;
							4'b0101:
								ball_direction <= 4'b1000;
							4'b0110:
								ball_direction <= 4'b1000;
							4'b0111:
								ball_direction <= 4'b1000;
							4'b1111:
								ball_direction <= 4'b1000;
							4'b1000:
								ball_direction <= 4'b1000;
						endcase
					
					end
				
				end
				//Si pega en la barra 0
				else if (((ball_xPosition+`ball_size/2 <= bar0_xPosition + `bar_width/2 + `ball_size) && 
							(ball_xPosition-`ball_size/2 >= bar0_xPosition - `bar_width/2 - `ball_size)) &&
							 (ball_yPosition + `ball_size/2 == `HEIGHT_SIZE_RES - `bar_height) && (!hit_bar_or_border) )  begin 
					hit_bar_or_border <= 1;
					//derecha
					if(ball_xPosition > (bar0_xPosition + `bar_width/6)) begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b0110;
							4'b0001:
								ball_direction <= 4'b0110;
							4'b0010:
								ball_direction <= 4'b0100;
							4'b0011:
								ball_direction <= 4'b0100;
							4'b0100:
								ball_direction <= 4'b0010;
							4'b0101:
								ball_direction <= 4'b0011;
							4'b0110:
								ball_direction <= 4'b0000;
							4'b0111:
								ball_direction <= 4'b0001;
							4'b1111:
								ball_direction <= 4'b0110;
							4'b1000:
								ball_direction <= 4'b0110;
						endcase
					//izquierda
					end else if (ball_xPosition < (bar0_xPosition - `bar_width/6) ) begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b0111;
							4'b0001:
								ball_direction <= 4'b0111;
							4'b0010:
								ball_direction <= 4'b0101;
							4'b0011:
								ball_direction <= 4'b0101;
							4'b0100:
								ball_direction <= 4'b0010;
							4'b0101:
								ball_direction <= 4'b0011;
							4'b0110:
								ball_direction <= 4'b0000;
							4'b0111:
								ball_direction <= 4'b0001;
							4'b1111:
								ball_direction <= 4'b0111;
							4'b1000:
								ball_direction <= 4'b0111;
								
						endcase
					
					end
					//caso del centro
					else begin
						case (ball_direction)
							4'b0000:
								ball_direction <= 4'b1111;
							4'b0001:
								ball_direction <= 4'b1111;
							4'b0010:
								ball_direction <= 4'b1111;
							4'b0011:
								ball_direction <= 4'b1111;
							4'b0100:
								ball_direction <= 4'b1111;
							4'b0101:
								ball_direction <= 4'b1111;
							4'b0110:
								ball_direction <= 4'b1111;
							4'b0111:
								ball_direction <= 4'b1111;
							4'b1111:
								ball_direction <= 4'b1111;
							4'b1000:
								ball_direction <= 4'b1111;
						endcase
					
					end
					
					
										
				end
				
				
				//La bola avanza
				else begin
					hit_bar_or_border <= 0;
					case (ball_direction)
						4'b000: begin
							ball_xPosition <= ball_xPosition +2; //cambio aqui antes era un 2
							ball_yPosition <= ball_yPosition +1; 
						end
						4'b001: begin
							ball_xPosition <= ball_xPosition -2; //antes 2
							ball_yPosition <= ball_yPosition +1; 
						end
						4'b010: begin
							ball_xPosition <= ball_xPosition +1;
							ball_yPosition <= ball_yPosition +1;
						end
						4'b011: begin
							ball_xPosition <= ball_xPosition -1;
							ball_yPosition <= ball_yPosition +1; 
						end
						4'b100: begin
							ball_xPosition <= ball_xPosition +2; //antes 2
							ball_yPosition <= ball_yPosition -1;
						end
						4'b101: begin
							ball_xPosition <= ball_xPosition -2; //antes 2
							ball_yPosition <= ball_yPosition -1; 
						end
						4'b110: begin
							ball_xPosition <= ball_xPosition +1;
							ball_yPosition <= ball_yPosition -1; 
						end
						4'b111: begin
							ball_xPosition <= ball_xPosition -1;
							ball_yPosition <= ball_yPosition -1; 
						end
						4'b1111: begin
							ball_yPosition <= ball_yPosition -1; 
						end
						4'b1000:begin
							ball_yPosition <= ball_yPosition +1; 
						end
						
					endcase
				
				
				end
				
				
			end
		end
	
	end
	
	
	
	
		
	
	//Cuando mostrar la bola y la barra	
	always @ (*) begin
		if ( ((iReadRow <= `HEIGHT_SIZE_RES) && (iReadRow > `HEIGHT_SIZE_RES - `bar_height) && 
			 (iReadCol <= bar0_xPosition + `bar_width/2) && (iReadCol >= bar0_xPosition - `bar_width/2) ) || (
			 (iReadRow <= ball_yPosition + `ball_size/2) && (iReadRow >= ball_yPosition - `ball_size/2) &&
			 (iReadCol <= ball_xPosition + `ball_size/2 ) && (iReadCol >= ball_xPosition - `ball_size/2 ) )	|| 
			 ((iReadRow <= `bar_height) && 
			 (iReadCol <= bar1_xPosition + `bar_width/2) && (iReadCol >= bar1_xPosition - `bar_width/2) ) )
			display_bar_or_ball = 1;
		else
			display_bar_or_ball = 0;
		
	end
	
	

endmodule
