module register #(parameter N =4 )(
input clk,
input clr,
input load,
input [N-1:0]d,
output reg [N-1:0]q
);

always @ (posedge clk, posedge clr) begin
    if (clr)
        q <= 0;
    else if (load)   
        q <= d;
end 
endmodule 