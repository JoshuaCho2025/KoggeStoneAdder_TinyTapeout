/*
 * Copyright (c) 2024 Weihua Xiao
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_koggestone_adder8 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [7:0] a, b;
  wire [7:0] sum;
  
  assign a = ui_in[3:0];
  assign b = ui_in[7:4];

  wire [7:0] p; // Propagate
  wire [7:0] g; // Generate
  wire [7:0] c; // Carry

  // Precompute generate and propagate signals
  assign p = a ^ b; // Propagate
  assign g = a & b; // Generate

  // Stage 1: Compute generate signals for neighbor 1-bit pairs
  wire g1_1, g1_2, g1_3, g1_4, g1_5, g1_6, g1_7;
  wire p1_1, p1_2, p1_3, p1_4, p1_5, p1_6, p1_7;

  assign g1_1 = g[1] | (p[1] & g[0]);
  assign g1_2 = g[2] | (p[2] & g[1]);
  assign p1_2 = p[2] & p[1];
  assign g1_3 = g[3] | (p[3] & g[2]);
  assign p1_3 = p[3] & p[2];
  assign g1_4 = g[4] | (p[4] & g[3]);
  assign p1_4 = p[4] & p[3];
  assign g1_5 = g[5] | (p[5] & g[4]);
  assign p1_5 = p[5] & p[4];
  assign g1_6 = g[6] | (p[6] & g[5]);
  assign p1_6 = p[6] & p[5];
  assign g1_7 = g[7] | (p[7] & g[6]);
  assign p1_7 = p[7] & p[6];

  // Stage 2: Compute generate signals for 2-bit groups
  wire g2_2, g2_3, g2_4, g2_5, g2_6, g2_7;
  assign g2_2 = g1_2 | (p1_2 & g[0]);
  assign g2_3 = g1_3 | (p1_3 & g1_1);
  assign g2_4 = g1_4 | (p1_4 & g1_2);
  assign g2_5 = g1_5 | (p1_5 & g2_2);
  assign g2_6 = g1_6 | (p1_6 & g2_3);
  assign g2_7 = g1_7 | (p1_7 & g2_4);

  // Stage 3: Compute generate signals for 4-bit groups
  wire g3_4, g3_5, g3_6, g3_7;
  assign g3_4 = g2_4 | (p[4] & g[0]);
  assign g3_5 = g2_5 | (p[5] & g1_1);
  assign g3_6 = g2_6 | (p[6] & g2_2);
  assign g3_7 = g2_7 | (p[7] & g3_4);

  // Compute final carry signals
  assign c[0] = 0;                       // No carry into the first bit
  assign c[1] = g[0];                    // Carry for 1st bit
  assign c[2] = g1_1;                    // Carry for 2nd bit
  assign c[3] = g2_2;                    // Carry for 3rd bit
  assign c[4] = g3_4;                    // Carry for 4th bit
  assign c[5] = g3_5;                    // Carry for 5th bit
  assign c[6] = g3_6;                    // Carry for 6th bit
  assign c[7] = g3_7;                    // Carry for 7th bit

  // Sum computation
  assign sum = p ^ c;                               // XOR of propagate and carry

  assign uo_out = sum;   // Output the 8-bit sum only
  assign uio_out = 8'b00000000;
  assign uio_oe = 8'b00000000;

endmodule
