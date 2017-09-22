`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'b0001 };
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `LCD ,  8'd3,16'b01001000	 };
	4: oInstruction = { `JMP ,  8'd4,16'b01001000	 };
	default:
		oInstruction = { `NOP ,  24'b10101010 };
	endcase	
end
	
endmodule
