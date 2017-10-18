module RAMWrapper(CLK,Reset,ReadyFlag,RamRead,wValue,RamReset);

input wire CLK;
input wire Reset;
input wire ReadyFlag;
input wire [2:0] RamRead;
output reg [2:0] wValue;
output reg RamReset;

always @(posedge CLK) begin
  if(Reset) begin
  RamReset=1;
    if(ReadyFlag) begin
      wValue=RamRead;
    end else begin
      wValue=3'b0;
    end
  end
end

endmodule
