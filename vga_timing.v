// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output wire [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output wire [10:0] hcount,
  output wire hsync,
  output wire hblnk,
  input wire pclk
  );

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
  wire htc; //horizontal terminal count
  reg [10:0] hc = 0;
    
  always @(posedge pclk)
  begin
    if (htc) hc <= 0;
    else hc <= hc + 1;
  end
  
  assign htc = (hc == 1055);
  assign hsync = (hc >= 840) && (hc <= 967);
  assign hblnk = (hc >= 800) && (hc <= 1055);
  
  
  wire vtc; //vertical terminal count
  reg [10:0] vc = 0;
  
  always @(posedge pclk)
  begin
    if (htc)
    begin
        if (vtc) vc <= 0;
        else vc <= vc + 1;
    end
  end
  
  assign vtc = (vc == 627);
  assign vsync = (vc >= 601) && (vc <= 604);
  assign vblnk = (vc >= 600) && (vc <= 627);
  
  assign vcount = vc;
  assign hcount = hc;
endmodule
