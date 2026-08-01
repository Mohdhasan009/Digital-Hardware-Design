module mux #(parameter N =4 )(
input [N-1:0] a,
input [N-1:0] b,
input         s,
output reg [N-1:0]c
    );

always @ (*) begin 
if (s)
    c = a;
else     
    c = b;
end 
endmodule
