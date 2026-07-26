module clk_divider #(parameter div_value =2499999)(
    input clk,
    output reg clk_out = 0
    );
    reg [31:0]count_reg=0;
    reg [31:0]next_count=0;
    
    
    // Logic for Counter 
    always @ (posedge clk) begin
    if (next_count == div_value)
      count_reg <= 8'b0;
    else 
    count_reg <= next_count;
    end 
  
    always @ (*)begin
    next_count = count_reg + 1;
    end   
    
    //Logic for clock divider 
    always @ (posedge clk)begin
    if (next_count == div_value )
    clk_out <= ~clk_out;
    else 
    clk_out <= clk_out;
   
    end
endmodule
