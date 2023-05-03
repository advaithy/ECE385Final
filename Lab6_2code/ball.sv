//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, collisionclk,
					input [7:0] keycode,
               output [64:0]  BallX, BallY, BallS );
    
    logic [64:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=340;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=260;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min= 80;      // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max= 585;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min= 40;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=460;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=3;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=3;      // Step size on the Y axis
	 logic upflag;
	 logic downflag;
	 logic rightflag;
	 logic leftflag;
	 logic [1:0] Balldirection;

    assign Ball_Size = 26;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
        begin 
				 if ( ((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max) /*&& (ballcollsig == 0)*/)  // Ball is at the bottom edge, BOUNCE!
					  downflag = 1;
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min /*&& (ballcollsig == 0)*/)  // Ball is at the top edge, BOUNCE!
					  upflag = 1;
					  
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max /*&& (ballcollsig == 0)*/)  // Ball is at the Right edge, BOUNCE!
					  rightflag = 1;
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min /*&& (ballcollsig == 0)*/)  // Ball is at the Left edge, BOUNCE!
					  leftflag = 1;
					  
				 case (keycode)
					8'h04 : begin
							  if (!leftflag)
								begin
									Ball_Y_Motion <= 0;//A
									Ball_X_Motion <= -2;
									Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
									Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
									Balldirection = 2'b01;
								end
							  else
								begin
									leftflag = 0;
								end
							  end
					        
					8'h07 : begin
							  if (!rightflag)
								begin
									Ball_Y_Motion <= 0;//D
									Ball_X_Motion <= 2;
									Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
									Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
									//Balldirection;
								end
							  else
								begin
									rightflag = 0;
								end
							  end

							  
					8'h16 : begin
							  if (!downflag)
								begin
									Ball_Y_Motion <= 2;//S
									Ball_X_Motion <= 0;
									Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
									Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
									Balldirection = 2'b10;
								end
							  else
								begin
									downflag = 0;
								end
							 end
							  
					8'h1A : begin
							  if (!upflag)
								begin
									Ball_Y_Motion <= -2;//W
									Ball_X_Motion <= 0;
									Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
									Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
									Balldirection = 2'b00;
								end
							  else
								begin
									upflag = 0;
								end
							 end	  
					default: ;
			   endcase	
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 
//	 logic [16:0] corner1mapaddress, corner2mapaddress, corner3mapaddress, corner4mapaddress, mapaddress1, mapaddress2;
//	 logic collisionsig1, collisionsig2;
//	 logic ballcollsig;
//	 
//	 //corner1          corner2
//	 //corner3          corner4
//	 
//	 assign corner1mapaddress = (((BallX * 1) / 2) + ((BallY * 1) / 2) * 320);
//	 assign corner2mapaddress = ((((BallX + 32) * 1) / 2) + ((BallY * 1) / 2) * 320);
//	 assign corner3mapaddress = (((BallX * 1) / 2) + (((BallY + 32) * 1) / 2) * 320);	
//	 assign corner4mapaddress = (((BallX + 32) * 1) / 2) + ((((BallY + 32) * 1) / 2) * 320);
//	 
//	 always_comb begin
//	 if (Balldirection == 2'b00) //up direction
//		begin
//			mapaddress1 = corner1mapaddress;
//			mapaddress2 = corner2mapaddress;
//		end
//	 else if (Balldirection == 2'b01) //left direction
//		begin
//			mapaddress1 = corner1mapaddress;
//			mapaddress2 = corner3mapaddress;
//		end
//	 else if (Balldirection == 2'b10) //down direction
//		begin
//			mapaddress1 = corner3mapaddress;
//			mapaddress2 = corner4mapaddress;
//		end
//	 else //right direction
//		begin
//			mapaddress1 = corner2mapaddress;
//			mapaddress2 = corner4mapaddress;
//		end
//	end
//	
//	finalmapedit_rom collisions1(.clock(collisionclk), .address(mapaddress1), .q(collisionsig1));
//	finalmapedit_rom collisions2(.clock(collisionclk), .address(mapaddress2), .q(collisionsig2));
//
//	always_comb begin
//	if(collisionsig1 || collisionsig2)
//		ballcollsig = 1;
//	else 
//		ballcollsig = 0;
//	end
	
endmodule
