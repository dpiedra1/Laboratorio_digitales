`include "VGA_DEFINES.v"


module VH_GENERATOR(
	input Clock_25,
	input Reset,
	output reg h_synch,
	output reg v_synch,
	output reg signed [10:0] pixel_count,  
	output reg [9:0] line_count
	);

   
// Contador lleva la cuenta de los pixeles por linea, inicia en el inicio de disp
always @ (posedge Clock_25 or posedge Reset) begin
    if (Reset) begin
        pixel_count <= 11'h000;
    end
	 
    else if (pixel_count == (`H_TOTAL - 1)) begin
	     pixel_count <= 11'h000;
    end
    else begin
        pixel_count <= pixel_count +1;      
	 end
end


// Contador de las lineas
always @ (posedge Clock_25 or posedge Reset) begin
    if (Reset) begin
        line_count <= 10'h000;
	 end
    
    else if ((line_count == (`V_TOTAL - 1)) && (pixel_count == (`H_TOTAL - 1))) begin //llego al final del frame
        line_count <= 10'h000;
    end
	 
    else if ((pixel_count == (`H_TOTAL - 1))) begin //llego al final de la linea
        line_count <= line_count + 1;
	 end
end



// Se crea el pulso horizontal
always @ (posedge Clock_25 or posedge Reset) begin
    if (Reset) begin
        h_synch <= 1'b1;
    end
	 
    else if (pixel_count == (`WIDTH_SIZE_RES + `H_FRONT_PORCH -1)) begin
        h_synch <= 1'b0;
	 end
    
    else if (pixel_count == (`H_TOTAL - `H_BACK_PORCH -1)) begin//lo mismo que la duracion del pulso
        h_synch <= 1'b1;
	 end
		  
	//Si no cae en ninguna condicion de mantiene en el valor anterior
end




// Se crea el pulso vertical
always @ (posedge Clock_25 or posedge Reset) begin
    if (Reset) begin
        v_synch = 1'b1;
	 end
    else if ((line_count == (`HEIGHT_SIZE_RES + `V_FRONT_PORCH -1) && (pixel_count == `H_TOTAL - 1))) begin
        v_synch = 1'b0;
    end
    else if ((line_count == (`V_TOTAL - `V_BACK_PORCH - 1)) && (pixel_count == (`H_TOTAL - 1))) begin //lo mismo que la duracion del pulso
        v_synch = 1'b1;
	 end
end



endmodule 
