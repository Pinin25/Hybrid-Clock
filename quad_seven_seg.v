//This is the top level design for EE178 Lab #2.
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
`timescale 1 ns / 1 ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.
module quad_seven_seg (
input wire clk,
input wire [3:0] val3,
input wire dot3,
input wire [3:0] val2,
input wire dot2,
input wire [3:0] val1,
input wire dot1,
input wire [3:0] val0,
input wire dot0,
output reg an3,
output reg an2,
output reg an1,
output reg an0,
output reg ca,
output reg cb,
output reg cc,
output reg cd,
output reg ce,
output reg cf,
output reg cg,
output reg dp
);
// Describe the actual circuit for the assignment.
wire en;
reg [3:0] val;
reg dot;
reg [10:0] big_ctr = 0;
reg [1:0] step = 0;

assign en = (big_ctr == 0);
always @(posedge clk)
begin
    if (en) step <= step + 1;
end

always @(posedge clk)
begin
    big_ctr <= big_ctr + 1;
end

always @*
begin
    {an3, an2, an1, an0} = ~(4'b0001 << step);
end

always @*
begin
    case (step)
        0: begin
            val = val0;
            dot = dot0;
           end
        1: begin
            val = val1;
            dot = dot1;
           end
        2: begin
            val = val2;
            dot = dot2;
           end
        3: begin
            val = val3;
            dot = dot3;
           end
    endcase
end

always @*
begin
    case (val)
        4'h0: {cg, cf, ce, cd, cc, cb, ca} = 7'b1000000;
        4'h1: {cg, cf, ce, cd, cc, cb, ca} = 7'b1111001;
        4'h2: {cg, cf, ce, cd, cc, cb, ca} = 7'b0100100;
        4'h3: {cg, cf, ce, cd, cc, cb, ca} = 7'b0110000;
        4'h4: {cg, cf, ce, cd, cc, cb, ca} = 7'b0011001;
        4'h5: {cg, cf, ce, cd, cc, cb, ca} = 7'b0010010;
        4'h6: {cg, cf, ce, cd, cc, cb, ca} = 7'b0000010;
        4'h7: {cg, cf, ce, cd, cc, cb, ca} = 7'b1111000;
        4'h8: {cg, cf, ce, cd, cc, cb, ca} = 7'b0000000;
        4'h9: {cg, cf, ce, cd, cc, cb, ca} = 7'b0011000;
        4'hA: {cg, cf, ce, cd, cc, cb, ca} = 7'b0001000;
        4'hB: {cg, cf, ce, cd, cc, cb, ca} = 7'b0000011;
        4'hC: {cg, cf, ce, cd, cc, cb, ca} = 7'b1000110;
        4'hD: {cg, cf, ce, cd, cc, cb, ca} = 7'b0100001;
        4'hE: {cg, cf, ce, cd, cc, cb, ca} = 7'b0000110;
        4'hF: {cg, cf, ce, cd, cc, cb, ca} = 7'b0001110;
        default: {cg, cf, ce, cd, cc, cb, ca} = 7'b1111111;
    endcase
end

always @*
begin
    if (dot) dp = 1'b0;
    else dp = 1'b1;
end
endmodule