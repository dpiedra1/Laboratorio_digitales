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
	1: oInstruction = { `STO , `R7,16'd0  };
	2: oInstruction = { `STO ,`R3,16'd0     };
	3: oInstruction = { `LCD ,  8'd3,16'b01001000	 };//manda una H
	4: oInstruction = { `LCD ,  8'd4,16'b01001111	 };//manda una O
	5: oInstruction = { `LCD ,  8'd5,16'b01001100	 };//manda una L
	//6: oInstruction = { `LCD ,  8'd6,16'b01000001	 };//manda una A(no funciona)
	6: oInstruction = { `LCD ,  8'd6,16'b00100000	 };//manda un espacio
	7: oInstruction = { `LCD ,  8'd7,16'b01001101	 };//manda una M
	//8: oInstruction = { `LCD ,  8'd8,16'b01010101	 };//manda una U
	
	
	
	8: oInstruction = { `JMP ,  8'd8,16'b01001000	 };
	default:
		oInstruction = { `NOP ,  24'b10101010 };
	endcase	
end
	
endmodule
