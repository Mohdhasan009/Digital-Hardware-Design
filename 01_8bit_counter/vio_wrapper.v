module vio_wrapper(
input clk_100M

    );
    wire [7:0]count;
    wire rst;
    vio_0 in_vio (
  .clk(clk_100M),                // input wire clk
  .probe_in0(count),    // input wire [7 : 0] probe_in0
  .probe_out0(rst)  // output wire [0 : 0] probe_out0
);
    
    top_counter in_top(.clk_100M(clk_100M),.rst(rst),.count(count));
endmodule
