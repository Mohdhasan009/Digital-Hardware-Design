module top_counter(
input clk_100M,rst,
output[7:0]count
);
wire clk_5Hz,clk_1Hz;

 clk_wiz_0 clk_wiz_01(
    .clk_out1(clk_5Hz),    
    .clk_in1(clk_100M)      
);  
clk_divider #(.div_value (2499999)) clk_divider_01(.clk(clk_5Hz),.clk_out(clk_1Hz));

counter_8bit in01(.clk(clk_1Hz), .rst(rst), .count(count));
endmodule