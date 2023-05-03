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


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, WallX, WallY, Wall_size, BackgX, BackgY, Backg_size, WplayerX, WplayerY, Wplayer_size,BombX, BombY, Bomb_size,
							  input         vga_clk, blank, 
							  input 			 Bomb_on,
                       output logic [7:0]  Red, Green, Blue);
    
    logic ball_on; 
	 logic wall_on;
	 logic player_on;
	 
	 logic bomb1_on;
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
	 
	 int WPDistX, WPDistY, WPSize;
	 assign WPDistX = DrawX - WplayerX;
	 assign WPDistY = DrawY - WplayerY;
	 assign WPSize = Wplayer_size;
	 
	 int BombDistX, BombDistY, BombSize;
	 assign BombDistX = DrawX - BombX;
	 assign BombDistY = DrawY - BombY;
	 assign BombSize = Bomb_size;
	 
//-----------------------------------------------------------------------------------//
//palette and rom instantiations
//BaseBackground

logic [18:0] collisionbg_rom_address;
logic [3:0] collisionbg_rom_q;
logic [3:0] collisionbg_palette_red, collisionbg_palette_green, collisionbg_palette_blue;

//
//logic [18:0] basebackground_rom_address;
//logic [3:0] basebackground_rom_q;
//logic [3:0] bg_palette_red, bg_palette_green, bg_palette_blue;

assign collisionbg_rom_address = (DrawX) + (DrawY) * 640;
//
//assign basebackground_rom_address = (DrawX) + (DrawY) * 640;
//
collisionbg_rom collisionbg_rom (
	.clock   (vga_clk),
	.address (collisionbg_rom_address),
	.q       (collisionbg_rom_q)
);

collisionbg_palette collisionbg_palette (
	.index (collisionbg_rom_q),
	.red   (collisionbg_palette_red),
	.green (collisionbg_palette_green),
	.blue  (collisionbg_palette_blue)
);

//backgroundimage_rom backgroundimage_rom (
//	.clock   (vga_clk),
//	.address (basebackground_rom_address),
//	.q       (basebackground_rom_q)
//);
//
//backgroundimage_palette backgroundimage_palette (
//	.index (basebackground_rom_q),
//	.red   (bg_palette_red),
//	.green (bg_palette_green),
//	.blue  (bg_palette_blue)
//);

//-------------------------------------------------------------------------------------//

//-----------------------------------------------------------------------------------//
//palette and rom instantiations
//WhiteFacingPlayer

logic [9:0] whiteplayer_rom_address;
logic [3:0] whiteplayer_rom_q;
logic [3:0] wp_palette_red, wp_palette_green, wp_palette_blue;

assign whiteplayer_rom_address = ((DrawX - WplayerX + 26) + (DrawY-WplayerY + 26) * 26);

whiteplayer3_rom whiteplayer2_rom (
	.clock   (vga_clk),
	.address (whiteplayer_rom_address),
	.q       (whiteplayer_rom_q)
);

whiteplayer3_palette whiteplayer2_palette (
	.index (whiteplayer_rom_q),
	.red   (wp_palette_red),
	.green (wp_palette_green),
	.blue  (wp_palette_blue)
);
//-------------------------------------------------------------------------------------//

//---------------------------------------------------------------------------------------
//palette and rom instantiations 
//bomb
//still need to find png of bomb and generate sv files with helper tools 

logic [9:0] bomb_rom_address;
logic [3:0] bomb_rom_q;
logic [3:0] bomb_palette_red, bomb_palette_green, bomb_palette_blue;

assign bomb_rom_address = ((DrawX - BombX + 26) + (DrawY-BombY + 26) * 26);

bomb_rom bomb_rom (
	.clock   (vga_clk),
	.address (bomb_rom_address),
	.q       (bomb_rom_q)
);

bomb_palette bomb_palette (
	.index (bomb_rom_q),
	.red   (bomb_palette_red),
	.green (bomb_palette_green),
	.blue  (bomb_palette_blue)
);



//--------------------------------------------------------------------------------------- 

	  
//    always_comb
//    begin:Ball_on_proc
//        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
//            ball_on = 1'b1;
//        else 
//            ball_on = 1'b0;
//     end
	 
	/*always_comb
    begin:Wall_on_proc
        if ( ( WDistX*WDistX + WDistY*WDistY) <= (WSize * WSize) ) 
            wall_on = 1'b1;
        else 
            wall_on = 1'b0;
     end*/  
	  
//	 always_comb
//    begin:wp_on_proc
//        if ((WPDistX <= WPSize) && (WPDistX >= WPSize - 32) && (WPDistY <= WPSize) && (WPDistY >= WPSize - 32)) 
//            player_on = 1'b1;
//        else 
//            player_on = 1'b0;
//     end

always 
       
    always_ff @ (posedge vga_clk)
    begin:RGB_Display
	 	  if (blank) 
			begin
            Red <= collisionbg_palette_red; 
            Green <= collisionbg_palette_green;
            Blue <= collisionbg_palette_blue;

//            Red <= bg_palette_red; 
//            Green <= bg_palette_green;
//            Blue <= bg_palette_blue;
				
//				if ((player_on == 1'b1)) 

				if(Bomb_on == 1'b1 && ((BombDistX < 0) && (BombDistX > (-26)) && (BombDistY < 0) && (BombDistY > -26)))
					begin
					Red <= bomb_palette_red;
					Green <=bomb_palette_green;
					Blue <= bomb_palette_blue;
					end
					
				if((WPDistX < 0) && (WPDistX > (-26)) && (WPDistY < 0) && (WPDistY > -26) && (wp_palette_red != 4'h4 && wp_palette_green != 4'h8 && wp_palette_blue != 4'h3))
					begin 	
						Red <= wp_palette_red;
						Green <= wp_palette_green;
						Blue <= wp_palette_blue;
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
