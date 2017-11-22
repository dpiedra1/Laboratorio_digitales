module Teclado(ClockT, DataT, Reset,mAccion,bandera);

input wire ClockT;
input wire DataT;
input wire Reset;
output reg bandera;
output reg [4:0] mAccion;

reg [3:0] bitcount=0;
reg [10:0] dataForm=8'b0;


always @(negedge ClockT or posedge Reset) begin 
  if(Reset) begin
    bitcount<=0;
    dataForm<=0;
	end
  else if(bitcount==10) begin
     bitcount<=0;
    dataForm<=0;
  end
  else begin
	 dataForm[bitcount]<=DataT;
	 bitcount<=bitcount+1;
  end
  
end
  
always @(*) begin
	if (bitcount==10) begin
	  case(dataForm[8:1])
			8'h4D: begin		//Inicio/Pausa
				bandera=1;
				mAccion=5'b00001;
			end
			8'h2A: begin		//v
				bandera=1;
				mAccion=5'b00010;
			end
				8'h22: begin	//X
				bandera=1;
				mAccion=5'b00100;
			end
				8'h4B: begin	//L
				bandera=1;
				mAccion=5'b01000;
			end
				8'h4C: begin	//;
				bandera=1;
				mAccion=5'b10000;
			end
				8'hF0: begin	//Fin de CMD
				bandera=0;
				mAccion=5'b00000;
			end
			default: begin
				bandera=0;
				mAccion=5'b00000;
			end
		 endcase
		 end
		 else begin
			bandera = 0;
			mAccion = 5'b00000;
		 end
	end
endmodule