module clk_divider #(parameter N = 12499)(
input clk,
output reg clk_200 =0 
    );
    reg [15:0]count_temp = 0;
    
    always @ (posedge clk) begin 
    if (count_temp == N)
            count_temp <= 0;
     else         
            count_temp <= count_temp + 1;
    end 
    always @ (posedge clk) begin 
    if (count_temp == N)
        clk_200 = ~clk_200;
    else     
        clk_200 = clk_200;