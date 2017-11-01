module Teclado(ClockT, DataT, DataO, Reset,mIzq,mDer,mArriba,mAbajo);

input wire Clock25;
input wire DataT;
output reg [9:0] DataO;
input wire Reset;
output reg mIzq,mDer,mArriba,mAbajo;

reg [3:0] bitcount;
reg [9:0] dataForm;

always @(negedge ClockT) begin 
  if(Reset) begin
    bitcount<=0;
    dataForm<=8'b0;
  end else if (bitcount>0 && bitcount<12) begin
      if(bitcount==1) begin
        dataForm<=DataT;
        bitcount<=bitcount+4'b1;
      end else begin
        dataForm<={DataT,dataForm};
        bitcount<=bitcount+4'b1;
      end
  end else if (bitcount==0) begin
    bitcount<=bitcount+4'b1;
  end else begin
    bitcount<=0;
    DataO<=dataForm;
  end
end
  
always @(*) begin
  case(DataO[7:0])
    8'h1D: begin
      mArriba=1;
    end
    8'h1C: begin
      mIzq=1;
    end
    8'h1B: begin
      mAbajo=1;
    end
    8'h23: begin
      mDer=1;
    end
    default:
      mDer,mIzq,mArriba,mAbajo=0;
  end
endmodule


