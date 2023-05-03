module block(input Reset, frame_clk,
					input [7:0] keycode,
               output [64:0]  BallX, BallY, BallS );
					
					
logic [64:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=100;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=100;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=479;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
	 assign Ball_Size = 5;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
		  else
				begin
				//nothing
				end
	 end
		  
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
endmodule 

module background(input Reset, frame_clk,
					input [7:0] keycode,
               output [64:0]  BallX, BallY, BallS );
					
					
logic [64:0] Ball_X_Pos, Ball_Y_Pos, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=640;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=480;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
	 assign Ball_Size = 1;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
		  else
				begin
				//nothing
				end
	 end
		  
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
endmodule 



module bomb(input Reset, frame_clk,
					input [7:0] keycode,
					input [64:0] playerX, playerY,
               output [64:0]  BallX, BallY,
					output Bomb_On);
					
	logic [64:0] Ball_X_Pos, Ball_Y_Pos;

	
	 
    parameter [9:0] Ball_X_Center = 0;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 0;  // Center position on the Y axis
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
		  else
				begin
				
				case(keycode) 
				8'h2c: begin //apparently this is the keycode for spacebar
					Ball_X_Pos <= playerX;
					Ball_Y_Pos <= playerY;
					Bomb_On <= 1'b1;
					end
				default: ;
				//nothing
				endcase
			end
	 end
	 
assign BallX = Ball_X_Pos;
   
assign BallY = Ball_Y_Pos;
endmodule

					