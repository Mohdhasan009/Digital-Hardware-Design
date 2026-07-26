module fsm_11011(
input input_pulse,
input clear,
input inp_01,
output reg [2:0] pr_state,
output reg det=0
    );
   
   
   reg [2:0] nxt_state;
    parameter s0 = 3'b000, 
              s1 = 3'b001, 
              s2 = 3'b010, 
              s3 = 3'b011, 
              s4 = 3'b100;
              
 always @ (posedge input_pulse, posedge clear) begin
    if (clear) 
        pr_state <= s0;
    else     
        pr_state <= nxt_state;       
 end 
 always @ (*)begin
 nxt_state = pr_state ;      
 
 case (pr_state)
 
 s0: if (inp_01 == 1'b1)
        nxt_state = s1;
     else    
        nxt_state = s0;
        
  s1: if (inp_01 == 1'b1)
        nxt_state = s2;
     else    
        nxt_state = s0;
        
  s2: if (inp_01 == 1'b0)
        nxt_state = s3;
     else    
        nxt_state = s2; 
        
  s3: if (inp_01 == 1'b1)
        nxt_state = s4;
     else    
        nxt_state = s0;        
         
  s4: if (inp_01 == 1'b1)
        nxt_state = s2;
     else    
        nxt_state = s0;      
        default: nxt_state = s0;
   endcase
 end 
 
 always @ (posedge input_pulse, posedge clear) begin
 if (clear)
        det <= 0;
 else if (pr_state == s4 && inp_01 == 1'b1)
      det <= 1;
 else 
     det <= 0;
 end 
endmodule