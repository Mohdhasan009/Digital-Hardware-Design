module vio_wrapper(
input clk
    );
wire [2:0] pr_state;
wire det;
wire clear;
wire inp_1;
wire inp_0;
    vio_0 vio_wrap (
  .clk(clk),                // input wire clk
  .probe_in0(pr_state),    // input wire [2 : 0] probe_in0
  .probe_in1(det),    // input wire [0 : 0] probe_in1
  .probe_out0(clear),  // output wire [0 : 0] probe_out0
  .probe_out1(inp_1),  // output wire [0 : 0] probe_out1
  .probe_out2(inp_0)  // output wire [0 : 0] probe_out2
);

top_seq top_seq_01 (.clk_100M(clk),.pr_state(pr_state),.det(det),.clear(clear),.inp_1(inp_1),.inp_0(inp_0));

endmodule
