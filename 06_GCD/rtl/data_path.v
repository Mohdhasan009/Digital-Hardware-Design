module datapath (
input clk,
input clr,
input xld,
input yld,
input gld,
input xmsel,
input ymsel,
input[3:0]x_in,
input[3:0]y_in,
output wire [3:0] gcd,
output reg eqflg,
output reg ltflg
);

wire [3:0] x, y, x1, y1;
wire [3:0] xmy, ymx, gcd_out;

assign xmy = x - y;
assign ymx = y - x;

always @(*) begin 
if (x == y)
    eqflg = 1;
else     
    eqflg = 0;
end 

always @(*) begin 
if (x < y)
    ltflg = 1;
else     
    ltflg = 0;
end 

// modules for muxes 

mux #(.N(4)) 
    mux_u1 (
    .a(x_in),
    .b(xmy),
    .c(x1),
    .s(xmsel)
);

mux #(.N(4))
    mux_u2 (
    .a(y_in),
    .b(ymx),
    .c(y1),
    .s(ymsel)
);

// modules for registers

register #(.N(4))
register_u1 (
    .clk(clk),
    .clr(clr),
    .load(xld),
    .d(x1),
    .q(x)
);

register# (.N(4))
register_u2 (
    .clk(clk),
    .clr(clr),
    .load(yld),
    .d(y1),
    .q(y)
);

register #(.N(4))
register_u3 (
    .clk(clk),
    .clr(clr),
    .load(gld),
    .d(x),
    .q(gcd_out)
);

assign gcd = gcd_out;

endmodule 