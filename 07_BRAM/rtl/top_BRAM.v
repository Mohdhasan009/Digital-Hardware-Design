module top_BRAM(
    input clk,
    output reg [3:0] max = 0
    );
    reg [3:0] count_temp = 0;    
    wire [3:0] dout;    
    
    always @ (posedge clk )begin 
    if (count_temp == 4'd9)
        count_temp <= count_temp;
    else 
        count_temp <= count_temp +1; 
    end 
    
    
blk_mem_gen_0 u1 (
  .clka(clk),    // input wire clka
  .addra(count_temp),  // input wire [3 : 0] addra
  .douta(dout)  // output wire [3 : 0] douta
);

always @ (*) begin 
    if (max < dout)
        max = dout;
    else     
        max = max;
    
end
endmodule

