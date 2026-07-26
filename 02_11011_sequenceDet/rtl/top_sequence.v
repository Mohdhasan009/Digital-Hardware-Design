module top_seq(
input clk_100M,
input clear,
input inp_1,
input inp_0,
output det,
output[2:0]pr_state
    );
    wire clk_5M;
    wire clk_200;
    wire input_pulse;
    
     clk_wiz_0 in_clk_wiz_01 (
    .clk_out1(clk_5M),     
    .clk_in1(clk_100M)     
);
clk_div #(. div_value(12499))in_clk(.clk(clk_5M),.clk_out(clk_200));

input_pulse in01_pulse (.clk_200(clk_200),.inp_1(inp_1),.inp_0(inp_0),.input_pulse(input_pulse));

fsm_11011 in_fsm_ (.input_pulse(input_pulse),.clear(clear),.inp_01(inp_1),.det(det),.pr_state(pr_state));

