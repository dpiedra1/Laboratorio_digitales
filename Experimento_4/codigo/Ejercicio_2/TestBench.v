`timescale 1ns / 1ps

// ******** Testbench para el modulo VGA

/*module TestBench;

	// Inputs
	reg Clock;
	reg Reset;

	// Outputs
	wire [9:0]column_count;
	wire [8:0]row_count;
	wire VGA_HSYNC;
	wire VGA_VSYNC;

	// Instantiate the Unit Under Test (UUT)
	VGA_Control uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.column_count(column_count),
		.row_count(row_count),
		.VGA_HSYNC(VGA_HSYNC),
		.VGA_VSYNC(VGA_VSYNC)
	);
	
	always
	begin
		#5  Clock =  ! Clock;

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
*/


// ******** Testbench para la miniAlu

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;
	reg BTN_EAST =0;
	reg BTN_SOUTH =0;
	reg BTN_WEST =0;
	reg BTN_NORTH =0;
	reg PS2_DATA;
	reg PS2_CLK;

	// Outputs
	wire VGA_RED;
	wire VGA_GREEN;
	wire VGA_BLUE;
	wire VGA_HSYNC;
	wire VGA_VSYNC;

	// Instantiate the Unit Under Test (UUT)
	MiniAlu dut
	(
		.Clock(Clock),
	   .Reset(Reset),
	   .BTN_EAST(BTN_EAST),
	   .BTN_NORTH(BTN_NORTH),
	   .BTN_SOUTH(BTN_SOUTH),
	   .BTN_WEST(BTN_WEST),
	   .PS2_DATA(PS2_DATA),
	   .PS2_CLK(PS2_CLK),
	   .VGA_HSYNC(VGA_HSYNC),
	   .VGA_VSYNC(VGA_VSYNC),
	   .VGA_RED(VGA_RED),
      .VGA_GREEN(VGA_GREEN),
	   .VGA_BLUE(VGA_BLUE)
 
);
	
	always
	begin
		#5  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		PS2_DATA =1;
		PS2_CLK =1;

		
		// Wait 100 ns for global reset to finish
		#100;
		Reset = 1;
		#50
		Reset = 0;

		#8
		PS2_DATA=0;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=1;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=0;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELO
		PS2_DATA=1;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=1;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=1;
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=0; 
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=0; 
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=0; 
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=1; 
		#2.5
		PS2_CLK =0; //RELOJ
		#2.5
		PS2_CLK =1; //RELOJ
		PS2_DATA=1;
		#2.5 
		PS2_CLK =0; //RELOJ
		#2.5 
		PS2_CLK =1; //RELOJ

		
        
		// Add stimulus here

	end
      
endmodule







