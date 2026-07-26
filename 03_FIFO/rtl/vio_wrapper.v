module vio_wrapper(
input clk
    );
    
    wire rst, read, write, full, empty, almost_full, almost_empty ;
    wire [3:0]data_count,dout,din;
    
    vio_0 your_instance_name (
  .clk(clk),                // input wire clk
  .probe_in0(dout),    // input wire [3 : 0] probe_in0
  .probe_in1(data_count),    // input wire [3 : 0] probe_in1
  .probe_in2(full),    // input wire [0 : 0] probe_in2
  .probe_in3(empty),    // input wire [0 : 0] probe_in3
  .probe_in4(almost_empty),    // input wire [0 : 0] probe_in4
  .probe_in5(almost_full),    // input wire [0 : 0] probe_in5
  .probe_out0(din),  // output wire [3 : 0] probe_out0
  .probe_out1(read),  // output wire [0 : 0] probe_out1
  .probe_out2(write),  // output wire [0 : 0] probe_out2
  .probe_out3(rst)  // output wire [0 : 0] probe_out3
);

top_FIFO inst1 (.clk_100(clk),.rst(rst),.write(write),.read(read),.din(din),
                .data_count(data_count),.dout(dout),
                .full(full),.empty(empty),.almost_empty(almost_empty)
                ,.almost_full(almost_full));
endmodule
