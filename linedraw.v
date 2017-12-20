// File: linedraw.v
// This is the linedraw design for EE178 Lab #6.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module linedraw (
  input wire go,
  output wire busy,
  input wire [7:0] stax,
  input wire [7:0] stay,
  input wire [7:0] endx,
  input wire [7:0] endy,
  output wire wr,
  output wire [15:0] addr,
  input wire pclk
  );

  // Describe the actual linedraw for the assignment.
  // Please refer to the provided reference materials
  // or research line drawing algorithms.  The default
  // logic provided here will allow you to initially
  // draw pixels to test integration of your video
  // timing controller and the simulation environment.

  parameter IDLE = 1'b0;
  parameter RUN = 1'b1;
  
  reg state;
    
  wire [7:0] x0, x1, y0, y1, x_next, y_next, xa, xb, ya, yb;
  wire signed [7:0] dx, dy; 
  reg [7:0] x, y;
  
  wire signed [8:0] e2, err1, err2, err_next;
  reg signed [8:0] err;
  
  wire right, down, in_loop, complete, e2_gt_dy, e2_lt_dx;

  //FSM
  always @(posedge pclk)
  begin
    case (state)
        IDLE :  state <= go? RUN : IDLE;
        RUN :   state <= complete? IDLE : RUN;
        default : state <= IDLE;
    endcase
  end
  
  //Bresenham Line Drawing Algorithm
  assign in_loop = (state == RUN);
  
  //Data path for dx, dy, right, down
  assign x0 = stax;
  assign x1 = endx;
  assign right = (x1 > x0)? 1 : 0;
  assign dx = right? (x1-x0) : (x0-x1);
 
  assign y0 = stay;
  assign y1 = endy;
  assign down = (y1 > y0)? 1 : 0;
  assign dy = down? (y0-y1) : (y1-y0);
  
  //Data path for errors
  assign e2 = err << 1;
  assign e2_lt_dx = (e2 < dx)? 1 : 0;
  assign e2_gt_dy = (e2 > dy)? 1 : 0;
  
  assign err1 = e2_gt_dy? (dy + err) : err;
  assign err2 = e2_lt_dx? (dx + err1) : err1;
  assign err_next = (in_loop)? err2 : (dx+dy);

  //Data path for x and y
  assign xa = (right)? (x+1) : (x-1);
  assign xb = (e2_gt_dy)? xa : x;
  assign x_next = (in_loop)? xb : x0;
  
  assign ya = (down)? (y+1) : (y-1);
  assign yb = (e2_lt_dx)? ya : y;
  assign y_next = (in_loop)? yb : y0;
  
  //Out of loop
  assign complete = ((x == x1) && (y == y1));
  
  always @(posedge pclk)
  begin
    err <= err_next;
    x <= x_next;
    y <= y_next;
  end
    
  assign busy = in_loop;
  assign wr = in_loop;
  assign addr = {y,x};
  
endmodule
