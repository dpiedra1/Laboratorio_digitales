`timescale 1ns / 1ps
`include "Defintions.v"

`define SUBRUT 8'd8

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
	3: oInstruction = { `CALL ,`SUBRUT,16'h1     }; 
	4: oInstruction = { `STO , `R7,16'b0001 };
	5: oInstruction = { `JMP ,  8'd5,16'b01001000	 };
	
	`SUBRUT: oInstruction = { `STO, `R3,16'h1	 };
	`SUBRUT+1: oInstruction = { `RET , 8'd4,16'b01001000	 };
	
	default:
		oInstruction = { `NOP ,  24'b10101010 };
	endcase	
end
	
endmodule
