module Teclado(ClockT, DataT, DataO, Reset);

input wire Clock25;
input wire DataT;
output reg [7:0] DataO;
input wire Reset;

reg [3:0] bitcount;
reg [7:0] dataForm;

always @(negedge ClockT) begin 
  if(Reset) begin
    bitcount<=0;
  end else if (bitcount>0 && bitcount<9) begin
      if(bitcount==1) begin
        dataForm<=DataT;
        bitcount<=bitcount+4'b1;
      end else begin
        dataForm<={dataForm,DataT};
        bitcount<=bitcount+4'b1;
      end
  end else if (bitcount==0) begin
    bitcount<=bitcount+4'b1;
  end else begin
    bitcount<=0;
    DataO<=dataForm;
  end
end

endmodule
