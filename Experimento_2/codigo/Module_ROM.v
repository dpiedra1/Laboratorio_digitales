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

//	0: oInstruction = { `NOP ,24'd4000    };
//	1: oInstruction = { `STO , `R7,16'b0001 };
//	2: oInstruction = { `STO ,`R3,16'h1     }; 
//	3: oInstruction = { `STO, `R4,16'd1000 };
//	4: oInstruction = { `STO, `R5,16'd0     };  //j
//LOOP2:
//	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
//	6: oInstruction = { `STO ,`R1,16'h0     }; 	
//	7: oInstruction = { `STO ,`R2,16'd10000 };
//LOOP1:	
//	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
//	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
//	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
//	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
//	12: oInstruction = { `NOP ,24'd4000       }; 
//	13: oInstruction = { `ADD ,`R7,`R7,`R3    };
//	14: oInstruction = { `JMP ,  8'd2,16'b0   };
//	default:
//		oInstruction = { `LED ,  24'b10101010 };		//NOP
	
/*	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'b11111111 };
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `STO, `R4,16'd1000 };
	4: oInstruction = { `STO, `R5,16'd0     };  //j
//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     }; 	
	7: oInstruction = { `STO ,`R2,16'd10000 };
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `SUB ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP	
*/

/* Prueba actividad 2, parte 1
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'b0001 };	//valor inicial
	2: oInstruction = { `STO ,`R3,16'h2     };	//constante
	3: oInstruction = { `STO, `R4,16'd2000 };
	4: oInstruction = { `STO, `R5,16'd0     };  	//j contador 1
//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     };	//contador 2
	7: oInstruction = { `STO ,`R2,16'd20000 };
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `MUL ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
*/

/* Prueba activad 2, con signo */

	/*0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'd1 };	//valor inicial
	2: oInstruction = { `STO ,`R3,16'd2     };	//constante
	3: oInstruction = { `STO, `R4,16'd1000 };
	4: oInstruction = { `STO, `R5,16'd0     };  	//j contador 1
//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     };	//contador 2
	7: oInstruction = { `STO ,`R2,16'd10000 }; 
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `IMUL ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };	//NOP*/
	
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R0,16'd100 };	//R7
	2: oInstruction = { `STO ,`R1,16'd800     };	//R3
	3: oInstruction = { `NOP ,24'd4000    };
	4: oInstruction = { `IMUL_16 ,`R1,`R1,`R0 };
	5: oInstruction = { `LED ,8'b0,`R1,8'b0 };
	/*6: oInstruction = { `STO ,`R2,16'h0     }; //contador 	
	7: oInstruction = { `STO ,`R3,16'd1 };
	//LOOP1:	
	8: oInstruction = { `ADD ,`R2,`R2,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R2,`R1 };
	10: oInstruction = { `SHTRIGHT ,`R1,`R1,`R1 };*/
	
	default:
		oInstruction = { `LED ,  24'b10101010 };
		
		
	endcase	
end
	
endmodule