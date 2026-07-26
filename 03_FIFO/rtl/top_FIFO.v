module top_FIFO(
input clk_100,
input rst,
input read,
input write,
input [3:0] din,
output full,
output empty,
output almost_empty,
output almost_full,
output [3:0] dout,
output [3:0] data_count
    );
    
    fifo_generator_0 fifo (
  .clk(clk_pulse),                    // input wire clk
  .srst(rst),                  // input wire srst
  .din(din),                    // input wire [3 : 0] din
  .wr_en(write),                // input wire wr_en
  .rd_en(read),                // input wire rd_en
  .dout(dout),                  // output wire [3 : 0] dout
  .full(full),                  // output wire full
  .almost_full(almost_full),    // output wire almost_full
  .empty(empty),                // output wire empty
  .almost_empty(almost_empty),  // output wire almost_empty
  .data_count(data_count)      // output wire [3 : 0] data_count
);


        wire clk_5M, clk_200,clk_pulse;
     clk_wiz_0 in_1
   (
    // Clock out ports
    .clk_out1(clk_5M),     // output clk_out1
   // Clock in ports
    .clk_in1(clk_100)      // input clk_in1
);

clk_divider #(.N (12499))inst1(.clk(clk_5M),.clk_200(clk_200));

wire clk_pulse;
inp_pulse inst2 (.clk_200(clk_200),.inp1(read),.inp2(write),.input_pulse(clk_pulse));
endmodule
