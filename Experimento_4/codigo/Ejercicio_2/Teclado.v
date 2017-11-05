module Teclado(ClockT, DataT, Reset,mIzq,mDer,mArriba,mAbajo,bandera);

input wire ClockT;
input wire DataT;
input wire Reset;
output reg mIzq,mDer,mArriba,mAbajo,bandera;

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
			8'h1D: begin
				bandera=1;
				mArriba=1;
			end
			8'h1C: begin
				bandera=1;
				mIzq=1;
			end
				8'h1B: begin
				bandera=1;
				mAbajo=1;
			end
				8'h23: begin
				bandera=1;
				mDer=1;
			end
				8'hF0: begin
				bandera=0;
				mDer=0;
				mIzq=0;
				mArriba=0;
				mAbajo=0;
			end
			default: begin
				bandera=0;
				mDer=0;
				mIzq=0;
				mArriba=0;
				mAbajo=0;
			end
		 endcase
		 end
	end
endmodule


