module input_pulse(
input clk_200,
input inp_1,
input inp_0,
output input_pulse
    );
    wire inp_pulse;
    reg Q =0;
    reg D=0;
    
    
   assign  inp_pulse = inp_1 | inp_0;
   
   always @ (posedge clk_200) begin
   Q <= D;
   end 
    
    always @(*) begin 
    D = inp_pulse;
    end
    
    assign input_pulse = Q;
endmodule
