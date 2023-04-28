//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, WallX, WallY, Wall_size, BackgX, BackgY, Backg_size,
							  input         vga_clk, blank,
                       output logic [7:0]  Red, Green, Blue);
    
    logic ball_on; 
	 logic wall_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 
	 int WDistX, WDistY, WSize;
	 assign WDistX = DrawX - WallX;
    assign WDistY = DrawY - WallY;
    assign WSize = Wall_size;
	 
	 int BDistX, BDistY, BSize;
	 assign BDistX = DrawX - BackgX;
	 assign BDistY = DrawY - BackgY;
	 assign BSize = Backg_size;
	 
//-----------------------------------------------------------------------------------//
//palette and rom instantiations
//BaseBackground

logic [18:0] basebackground_rom_address;
logic [3:0] basebackground_rom_q;
logic [3:0] bg_palette_red, bg_palette_green, bg_palette_blue;

assign basebackground_rom_address = (DrawX) + (DrawY) * 640;

backgroundimage_rom backgroundimage_rom (
	.clock   (vga_clk),
	.address (basebackground_rom_address),
	.q       (basebackground_rom_q)
);

backgroundimage_palette backgroundimage_palette (
	.index (basebackground_rom_q),
	.red   (bg_palette_red),
	.green (bg_palette_green),
	.blue  (bg_palette_blue)
);

//-------------------------------------------------------------------------------------//
	 

	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end
	 
	/*always_comb
    begin:Wall_on_proc
        if ( ( WDistX*WDistX + WDistY*WDistY) <= (WSize * WSize) ) 
            wall_on = 1'b1;
        else 
            wall_on = 1'b0;
     end*/  
       
    always_ff @ (posedge vga_clk)
    begin:RGB_Display
	 	  if (blank) 
			begin
            Red <= bg_palette_red; 
            Green <= bg_palette_green;
            Blue <= bg_palette_blue;
				
				if ((ball_on == 1'b1)) 
					begin 	
						Red <= 8'hff;
						Green <= 8'h55;
						Blue <= 8'h00;
					end 
					
				if ((wall_on == 1'b1)) 
					begin 
						Red <= 8'h80; 
						Green <= 8'h80;
						Blue <= 8'h80;
					end
			end 
		  else
		  begin
			Red <= 8'h00; 
         Green <= 8'h00;
         Blue <= 8'h00;
		  end
		  
    end 
	  
    
endmodule
