module FSM (input logic Clk, Run, Reset,
				output logic animation1, animation2);
				
				
				enum logic [3:0] {animpt1, animpt2 /*, animpt3*/} curr_state, next_state;
				
				always_ff @ (posedge Clk)  
				begin
				if (Reset)
					curr_state <= animpt1;
				else 
					curr_state <= next_state;
				end
				
				
				always_comb
				begin
				
					next_state = curr_state;
					unique case (curr_state)
					
					animpt1: next_state = animpt2;
					animpt2: next_state = animpt1; //next_state = animpt3;
					//animpt3: next_state = animpt1;
					endcase
					
					case(curr_state)
					animpt1: 
					begin
					animation1 = 1'b1;
					animation2 = 1'b0;
					end
					
					animpt2:
					begin
					animation1 = 1'b0;
					animation2 = 1'b1;
					end
					endcase
				end
endmodule 
					
					