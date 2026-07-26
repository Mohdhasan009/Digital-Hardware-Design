module clk_divider_tb(

    );
    reg clk = 0;
    wire clk_200;
    
    clk_divider #(10) in_1(.clk(clk),.clk_200(clk_200));

    always #5 clk = ~clk;
endmodule
