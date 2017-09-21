`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V
	
`default_nettype none	
`define NOP      4'd0
`define LED      4'd2
`define BLE      4'd3
`define STO      4'd4
`define ADD      4'd5
`define JMP      4'd6
`define SUB      4'd7
`define MUL      4'd8  //Multiplica usando el operador *
`define IMUL_4   4'd9  //Multiplica usando arrayMultiplier de 4 bits
`define IMUL_16  4'd10 //Multiplica usando arrayMultiplier de 16 bits
`define IMUL2_4  4'd11 //Multiplica usando LUT de 4 bits
`define IMUL2_16 4'd12 //Multiplica usando LUT de 16 bits
`define SHTRIGHT 4'd13

`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7



`endif