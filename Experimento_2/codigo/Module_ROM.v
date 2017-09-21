`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd11
`define LOOP2 8'd8
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)



// Prueba actividades 1 2 3 y 4 (Imprime en los LEDs)

	/*0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO ,`R7,16'hFFFA };	//Primer multiplicando
	2: oInstruction = { `STO ,`R6,16'hFAFA };	//Segundo multiplicando
	3: oInstruction = { `NOP ,24'd4000    };
	4: oInstruction = {`IMUL_16,`R7,`R7,`R6}; //Aqui se cambia el tipo de 
															//multiplicacion que se quiere usar
	5: oInstruction = { `STO ,`R3,16'd1     };	//constante
	6: oInstruction = { `STO, `R4,16'd1000 };
	7: oInstruction = { `STO, `R5,16'd0     };  	//j contador 1
//LOOP2:
	8: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	9: oInstruction = { `STO ,`R1,16'h0     };	//contador 2
	10: oInstruction = { `STO ,`R2,16'd10000 }; 
//LOOP1:	
	11: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	12: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	13: oInstruction = { `ADD ,`R5,`R5,`R3    };
	14: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	15: oInstruction = { `NOP ,24'd4000       }; 
	16: oInstruction = { `SHTRIGHT ,`R7,`R7,`R7 }; //Se desplaza el resultado para
																  //para mostrarlo en los LEDs
	17: oInstruction = { `JMP ,  8'd5,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };	//NOP*/
	
	// Prueba para probar en simulacion que la multiplicacion funciona
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'hFFFF }; //Primer multiplicador	
	2: oInstruction = { `STO ,`R3,16'hFFFA  }; //Segundo multiplicador
	3: oInstruction = { `NOP ,24'd4000    };
	4: oInstruction = { `IMUL2_4 ,`R7,`R7,`R3 }; //Cambiar el tipo de multiplicador
																//que se quiere usar
	5: oInstruction = { `NOP ,24'd4000    };
		
	default:
		oInstruction = { `LED ,  24'b10101010 };
		
		
	endcase	
end
	
endmodule