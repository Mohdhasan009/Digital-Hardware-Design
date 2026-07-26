module counter_8bit(
    input clk,
    input rst,
    output [7:0] count
    );
     reg [7:0]count_temp =0;
     
    always@(posedge clk) begin
    if (rst)
    count_temp <= 8'b00000000;
    else
    count_temp <= count_temp + 1;
    end 
    
    assign count= count_temp;
    
endmodule