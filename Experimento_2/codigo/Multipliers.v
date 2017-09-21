//En este archivo se encuentran los bloques mult16bits y mult4bits que multiplican dos registros de 4 y 16 bits respectivamente
//ademas de los bloques que a su vez son utilizados por los bloques multiplicadores


//Suma dos valores de un bit y un acarreo. El resultado es de un bit mas el acarreo
module adder (
	input wire sourceA,
	input wire sourceB,
	input wire Ci,
	output wire result,
	output wire Co

);
	assign {Co,result} = sourceA + sourceB + Ci;
	
	
endmodule

module lut4(mulA,mulB,rMul);
input wire [3:0] mulA;
input wire [1:0] mulB;
output wire [7:0] rMul;

assign rMul = (mulB==2'b00) ? 8'b0 : (mulB==2'b01) ? mulA : (mulB==2'b10) ? mulA<<1 : (mulA<<1)+mulA;

endmodule

module lut(mulA,mulB,rMul);
input wire [15:0] mulA;
input wire [1:0] mulB;
output wire [31:0] rMul;

assign rMul = (mulB==2'b00) ? 8'b0 : (mulB==2'b01) ? mulA : (mulB==2'b10) ? mulA<<1 : (mulA<<1)+mulA;

endmodule

module mullut4(mulA,mulB,resultado4);
input wire [31:0] mulA;
input wire [31:0] mulB;
output wire [31:0] resultado4;

wire [7:0] resultLut1;
wire [7:0] resultLut2;


lut4 lsb(mulA[3:0],mulB[1:0],resultLut1);
lut4 msb(mulA[3:0],mulB[3:2],resultLut2);

assign resultado4=resultLut1+(resultLut2<<2);

endmodule

module mullut16(mulA,mulB,resultado16);
input wire [31:0] mulA;
input wire [31:0] mulB;
output wire [31:0] resultado16;

wire [31:0] resultLut161;
wire [31:0] resultLut162;
wire [31:0] resultLut163;
wire [31:0] resultLut164;
wire [31:0] resultLut165;
wire [31:0] resultLut166;
wire [31:0] resultLut167;
wire [31:0] resultLut168;


lut lut1(mulA[15:0],mulB[1:0],resultLut161);
lut lut2(mulA[15:0],mulB[3:2],resultLut162);
lut lut3(mulA[15:0],mulB[5:4],resultLut163);
lut lut4(mulA[15:0],mulB[7:6],resultLut164);
lut lut5(mulA[15:0],mulB[9:8],resultLut165);
lut lut6(mulA[15:0],mulB[11:10],resultLut166);
lut lut7(mulA[15:0],mulB[13:12],resultLut167);
lut lut8(mulA[15:0],mulB[15:14],resultLut168);

assign resultado16=(resultLut161+(resultLut162<<2)+(resultLut163<<4)+(resultLut164<<6)+(resultLut165<<8)+(resultLut166<<10)+(resultLut167<<12)+(resultLut168<<14));

endmodule

//Bloque que desplaza hacia la izquierda
module shiftleft #(parameter SHIFT_PLACES = 1)(
	input  wire [15:0] source,
	output wire [31:0] result
);

assign result = 0 + (source<<SHIFT_PLACES);

endmodule


//Multiplica dos valores, uno de un bit y el otro de 16
module mult_1bitx16bit(
	input wire [15:0] sourceA,
	input wire sourceB,
	output wire [15:0] result
);
	
	assign result = sourceB?sourceA:16'd0;
	
	
endmodule


//Bloque que multiplica dos numeros de 16 bits
// usando array multiplier
module mult16bits_arrayMult(
	input wire [15:0] sourceA,
	input wire [15:0] sourceB,
	output wire [31:0] result
);
	//Se crea el arreglo de las filas que se deben sumar
	wire [15:0] row_array [15:0];
	genvar index;
	generate
		for(index=0; index < 16; index = index +1) begin: gen_block
			mult_1bitx16bit inst (
				.sourceA(sourceA),
				.sourceB(sourceB[index]),
				.result(row_array[index])
			);
			
		end
	endgenerate
	
	//Se desplazan las filas y se llenan con 0's para hacerlas de 32 bits
	wire [31:0] row_array_32 [15:0];
	genvar j;
	generate 
		for(j=0; j<16; j = j+1) begin: gen_block2
			shiftleft #(.SHIFT_PLACES(j)) shiftleft_inst(
			.source(row_array[j]),
			.result(row_array_32[j])
			);
			
		end
	endgenerate

	// Se conectan los bloques adder
	wire [15:0] Co [15:0];
	wire [15:0] adders_result [15:0]; 
	genvar column,row;
	generate
		for (row = 0; row <15; row = row+1) begin: external_loop
			for (column =0; column<16; column = column +1) begin: internal_loop
				
				//Primera linea
				if(row == 0)begin
					if(column ==0) begin
						adder first_row_fc (
							.sourceA(row_array_32[row][column+1]),
							.sourceB(row_array_32[row+1][column+1]),
							.Ci(0),
							.Co(Co[row][column]),
							.result(result[row+1])
						);
					
					end
					else if (column == 15)begin
						adder first_row_lc (
							.sourceA(0),
							.sourceB(row_array_32[row+1][column+1]),
							.Ci(Co[row][column-1]),
							.Co(Co[row][column]),
							.result(adders_result[row][column])
						);
					end
					else begin
						adder first_row (
							.sourceA(row_array_32[row][column+1]),
							.sourceB(row_array_32[row+1][column+1]),
							.Ci(Co[row][column-1]),
							.Co(Co[row][column]),
							.result(adders_result[row][column])
						);
					end
				end
				
				// Ultima fila
				else if (row == 14) begin
					if(column ==0) begin
						adder last_row_fc (
							.sourceA(adders_result[row-1][column+1]),
							.sourceB(row_array_32[row+1][row+1]),
							.Ci(0),
							.Co(Co[row][column]),
							.result(result[row+1])
						);
					
					end
					else if (column == 15)begin
						adder last_row_lc (
							.sourceA(Co[row-1][column]),
							.sourceB(row_array_32[row+1][row+column+1]),
							.Ci(Co[row][column-1]),
							.Co(result[row+column+2]),
							.result(result[row+column+1])
						);
					end
					else begin
						adder last_row (
							.sourceA(adders_result[row-1][column+1]),
							.sourceB(row_array_32[row+1][row+column+1]),
							.Ci(Co[row][column-1]),
							.Co(Co[row][column]),
							.result(result[row+column+1])
						);
					end
				
				end
				
				//Filas intermedias
				else begin	
					if(column ==0) begin
						adder middle_row_fc (
							.sourceA(adders_result[row-1][column+1]), // [row-1][column+1]
							.sourceB(row_array_32[row+1][row+column+1]),
							.Ci(0),
							.Co(Co[row][column]),
							.result(result[row+1])
						);
					
					end
					else if (column == 15)begin
						adder middle_row_lc (
							.sourceA(row_array_32[row+1][row+column+1]),
							.sourceB(Co[row-1][column]),
							.Ci(Co[row][column-1]),
							.Co(Co[row][column]),
							.result(adders_result[row][column])
						);
					end
					else begin
						adder middle_row (
							.sourceA(row_array_32[row+1][row+column+1]),
							.sourceB(adders_result[row-1][column+1]),
							.Ci(Co[row][column-1]),
							.Co(Co[row][column]),
							.result(adders_result[row][column])
						);
					end
					
					
				end
						
			end
		end
	endgenerate
	
	assign result[0] = row_array_32[0];

endmodule

//Bloque que multiplica dos numeros de 4 bits
module mult4bits_arrayMult (
	input wire  [3:0] sourceB,
	input wire  [3:0] sourceA,
	output reg  [7:0] result
);
	
	
	reg [2:0] R0, R1, R2, R3, R4, R5, R6, R7;
	always @(*) begin
		R0[0] = sourceA[0]&sourceB[0];
		R1 = (sourceA[1]&sourceB[0]) + (sourceA[0]&sourceB[1]);
		R2 = (sourceA[2]&sourceB[0]) + (sourceA[1]&sourceB[1])+ 
		     (sourceA[0]&sourceB[2]) + (R1[2:1]);
		R3 = (sourceA[3]&sourceB[0]) + (sourceA[2]&sourceB[1]) +
			  (sourceA[1]&sourceB[2]) + (sourceA[0]&sourceB[3]) + (R2[2:1]);
		R4 = (sourceA[3]&sourceB[1]) + (sourceA[2]&sourceB[2]) + 
		     (sourceA[1]&sourceB[3]) + (R3[2:1]);
		R5 = (sourceA[3]&sourceB[2]) + (sourceA[2]&sourceB[3]) + 
		     (R4[2:1]);
		R6 = (sourceA[3]&sourceB[3]) + (R5[2:1]);
		R7 = R6[1];
		result = {R7[0], R6[0], R5[0], R4[0], R3[0], R2[0], R1[0], R0[0]};
	end

endmodule
