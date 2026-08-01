module gcd(
input clk,
input clr,
input go,
input [3:0]x_in,
input [3:0]y_in,
output [3:0]gcd 
);

wire eqflg, ltflg, xmsel, ymsel;
wire xld, yld, gld;

datapath u1 (
.clk(clk),
.clr(clr),
.xld(xld),
.yld(yld),
.gld(gld),
.xmsel(xmsel),
.ymsel(ymsel),
.x_in(x_in),
.y_in(y_in),
.gcd(gcd),
.eqflg(eqflg),
.ltflg(ltflg)
);

controlpath u2 (
.clk(clk),
.clr(clr),
.go(go),
.xld(xld),
.yld(yld),
.gld(gld),
.xmsel(xmsel),
.ymsel(ymsel),
.eqflg(eqflg),
.ltflg(ltflg)
);

endmodule 

