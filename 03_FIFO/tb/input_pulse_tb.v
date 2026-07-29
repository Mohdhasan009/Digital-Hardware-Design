module input_pulse_tb(

    );
    reg clk_200=0, inp1 = 0,inp2= 0;
    wire input_pulse;
    
    inp_pulse ins1(.clk_200(clk_200),.inp1(inp1),.inp2(inp2),.input_pulse(input_pulse));
    always #5 clk_200 = ~ clk_200;
    
    initial begin 
    #7; inp1= 1;
    #15; inp1 =0;
    #10; inp2 = 1;
    #20; inp2=0;
    end 
endmodule