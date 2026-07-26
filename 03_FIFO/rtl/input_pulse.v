module inp_pulse(
input clk_200,
input inp1,
input inp2,
output input_pulse
); 

reg Q = 0;
reg D = 0;
wire in_pulse;

assign in_pulse = inp1 | inp2;

always @ (posedge clk_200) begin
    Q <= D;
end     
    always @ (*) begin 
    D = in_pulse;
    end 
  assign input_pulse = Q;
endmodule