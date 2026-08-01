module controlpath(
input clk,
input clr,
input go,
input eqflg,
input ltflg,
output reg xmsel,
output reg ymsel,
output reg xld,
output reg yld,
output reg gld
    );
    
reg [2:0] pr_state,nxt_state;

parameter start = 3'b000, input1 = 3'b001, 
          test1 = 3'b010, test2 = 3'b011,
          update1 = 3'b100, update2 = 3'b101,
          done = 3'b110;

always @ (posedge clk, posedge clr) begin     
    if (clr)
        pr_state <= start;       
    else     
        pr_state <= nxt_state;
    end     

// FSM for States    

    always @ (*) begin 
    nxt_state = pr_state;
    
    case(pr_state)
    start: if (go)
                nxt_state = input1;
           else      
                nxt_state = start;
     input1:           
            nxt_state = test1;    
     test1: if (eqflg)
                nxt_state = done;
           else      
                nxt_state = test2;            
     test2: if (ltflg)
                nxt_state = update1;
           else      
                nxt_state = update2;             
     update1:
                nxt_state = test1;
     update2:
                  nxt_state = test1;
     done:
            nxt_state = done;             
    endcase
  end 
 
// FSM for Signals     

always @ (*) begin 
xmsel = 0;ymsel = 0;
xld = 0; yld = 0; gld = 0;

case (pr_state) 
    
    input1:begin 
            xmsel = 1;   xld = 1;
            ymsel = 1;   yld = 1;
end 
    update1:begin 
            yld = 1;
end             
    update2:begin 
            xld = 1;  
end             
    done:begin 
            gld = 1;
end             
    default: ;  
            
    endcase
end 
endmodule
