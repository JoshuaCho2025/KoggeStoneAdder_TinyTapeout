`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] b;           
  reg [7:0] a;
  wire [7:0] sum;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the 8-bit Kogge-Stone adder module:
  tt_um_koggestone_adder8 user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
    .ui_in  (a),       // 8-bit input (concatenated a and b)
    .uo_out (sum),      // 8-bit output for the sum
    .uio_in (b),     // IO path input
    .uio_out(uio_out),     // IO path output
    .uio_oe (uio_oe),      // IO enable path
    .ena    (ena),         // Enable signal
    .clk    (clk),         // Clock signal
    .rst_n  (rst_n)        // Reset (active low)
  );

 
  endmodule
