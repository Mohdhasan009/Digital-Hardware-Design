module counter_8bit_tb(

    );
   
    reg clk,rst;
    wire [7:0]count;
    
    counter_8bit u1(.clk(clk),.rst(rst),.count(count));
    
    initial begin 
    clk =0;
    rst = 1;
    end 
    initial begin 
    #500;
    rst = 0;
    forever #10 clk = ~clk;
    end 
endmodule
