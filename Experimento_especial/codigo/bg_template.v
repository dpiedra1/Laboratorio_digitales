`include "VGA_DEFINES.v"
`define background_color 3'b000 //negro
`define score_color      3'b001 //azul
`define width_number     20
`define height_number    40

`define score0_posX      25
`define score0_posY      400 

`define score1_posX      25
`define score1_posY      40

module bg_template(
	input wire signed [10:0] iReadCol,
	input wire [9:0]  iReadRow,
	input wire [1:0]  bar0_score,
	input wire [1:0]  bar1_score,
	output wire [2:0]  RGB_out
	
	);
	
	reg score0 =0;
	reg score1 =0;
	
	always @ * begin
		if ( ((iReadCol >= `score0_posX && iReadCol<`score0_posX+`width_number) || (iReadCol >= `score1_posX && iReadCol<`score1_posX+`width_number))
		&& ((iReadRow >= `score0_posY && iReadRow<`score0_posY+`height_number) || (iReadRow >= `score1_posY && iReadRow<`score1_posY+`height_number))   ) begin
	
			case (bar0_score) 
			
			2'b0: begin //Se dibuja un 0
				if(((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19) && (iReadRow-`score0_posY>=0 && iReadRow-`score0_posY<4))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<4) && (iReadRow-`score0_posY>=5 && iReadRow-`score0_posY<34))||((iReadCol-`score0_posX>=15 && iReadCol-`score0_posX<19)&& (iReadRow-`score0_posY>=5 && iReadRow-`score0_posY<34))||(iReadCol-`score0_posX<19 &&(iReadRow-`score0_posY>=35 && iReadRow-`score0_posY<39))) begin
					score0=1;
				end
				else begin
					score0=0;
				end
			end
			
			2'b1: begin //Se dibuja un 1
				if(iReadCol-`score0_posX>=15 && iReadCol-`score0_posX<19 && (iReadRow-`score0_posY>=0 && iReadRow-`score0_posY<39)) begin
					score0=1;
				end
				else begin
					score0=0;
				end
			end
			2'b10: begin //Se dibuja un 2
				if(((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=0 && iReadRow-`score0_posY<4))||((iReadCol-`score0_posX>=15 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=5 && iReadRow-`score0_posY<17))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=18 && iReadRow-`score0_posY<22))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<4)&&(iReadRow-`score0_posY>=23 && iReadRow-`score0_posY<34))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=35 && iReadRow-`score0_posY<39))) begin
					score0=1;
				end
				else begin
					score0=0;
				end
			end
			2'b11: begin //Se dibuja un 2
				if(((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=0 && iReadRow-`score0_posY<4))||((iReadCol-`score0_posX>=15 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=5 && iReadRow-`score0_posY<17))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=18 && iReadRow-`score0_posY<22))||((iReadCol-`score0_posX>=15 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=23 && iReadRow-`score0_posY<34))||((iReadCol-`score0_posX>=0 && iReadCol-`score0_posX<19)&&(iReadRow-`score0_posY>=35 && iReadRow-`score0_posY<39))) begin
					score0=1;
				end
				else begin
					score0=0;
				end
			end
			default:
				score0=0;
			endcase
			
			
			
			case (bar1_score) 
			2'b0: begin //Se dibuja un 0
				if(((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19) && (iReadRow-`score1_posY>=0 && iReadRow-`score1_posY<4))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<4) && (iReadRow-`score1_posY>=5 && iReadRow-`score1_posY<34))||((iReadCol-`score1_posX>=15 && iReadCol-`score1_posX<19)&& (iReadRow-`score1_posY>=5 && iReadRow-`score1_posY<34))||(iReadCol-`score1_posX<19 &&(iReadRow-`score1_posY>=35 && iReadRow-`score1_posY<39))) begin
					score1=1;
				end
				else begin
					score1=0;
				end
			end
			
			2'b1: begin //Se dibuja 1
				if(iReadCol-`score1_posX>=15 && iReadCol-`score1_posX<19 && (iReadRow-`score1_posY>=0 && iReadRow-`score1_posY<39)) begin
					score1=1;
				end
				else begin
					score1=0;
				end
			end
			2'b10: begin //Se dibuja un 2
				if(((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=0 && iReadRow-`score1_posY<4))||((iReadCol-`score1_posX>=15 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=5 && iReadRow-`score1_posY<17))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=18 && iReadRow-`score1_posY<22))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<4)&&(iReadRow-`score1_posY>=23 && iReadRow-`score1_posY<34))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=35 && iReadRow-`score1_posY<39))) begin					
					score1=1;
				end
				else begin
					score1=0;
				end
			end
					2'b11: begin //Se dibuja un 2
if(((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=0 && iReadRow-`score1_posY<4))||((iReadCol-`score1_posX>=15 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=5 && iReadRow-`score1_posY<17))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=18 && iReadRow-`score1_posY<22))||((iReadCol-`score1_posX>=15 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=23 && iReadRow-`score1_posY<34))||((iReadCol-`score1_posX>=0 && iReadCol-`score1_posX<19)&&(iReadRow-`score1_posY>=35 && iReadRow-`score1_posY<39))) begin					score1=1;
				end
				else begin
					score1=0;
				end
			end
			default: begin
				score1=0;
			end
			endcase
		end
	else begin
		score0 =0;
		score1 =0;
	end
	
end	
	assign RGB_out = score0 || score1 ? `score_color : `background_color;
	
	
endmodule
