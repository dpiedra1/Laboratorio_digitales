`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 13/09/2017
// Design Name:   LCD_Control
// Module Name:   D:/Proyecto/RTL/Dev/LCD_Control/TestBench.v
// Project Name:  LCD_Control
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LCD_Control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;

	// Outputs
	wire     oLCD_Enabled;
	wire     oLCD_RegisterSelect;
	wire     oLCD_ReadWrite;
	wire [3:0]oLCD_Data;

	// Instantiate the Unit Under Test (UUT)
	LCD_Control uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.LCD_E(oLCD_Enabled),
		.LCD_RS(oLCD_RegisterSelect),
		.LCD_RW(oLCD_ReadWrite),
		.SF_D(oLCD_Data),
		.send_chter(1),
		.chter_to_send(8'b01001000)
		
	);
	
	always
	begin
		#10  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 1;
		#50
		Reset = 0;
        
		// Add stimulus here

	end
      
endmodule

