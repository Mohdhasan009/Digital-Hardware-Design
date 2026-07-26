module clk_div #(parameter div_value = 12499)(
input clk,
output reg clk_out = 0
    );
    reg [31:0]count_temp = 0;
    
   always @ (posedge clk) begin 
   if (count_temp == div_value)
       count_temp <= 1'b0;
   else     
    count_temp <= count_temp +1;
   end     
   always @ (posedge clk) begin 
     if (count_temp == div_value)   
       clk_out <= ~clk_out;
       else
       clk_out = clk_out;
  end
endmodule