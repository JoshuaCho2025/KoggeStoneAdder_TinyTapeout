/* (c) Krishna Subramanian <https://github.com/mongrelgem>
 * For Issues & Bugs, report to <https://github.com/mongrelgem/Verilog-Adders/issues>
*/
/*
 * Copyright (c) 2024 Weihua Xiao
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none



module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  
  wire e;
  and #(1) (e, Pi, GiPrev);
  or #(1) (G, e, Gi);
  and #(1) (P, Pi, PiPrev);
  
endmodule

module SmallCircle(output Ci, input Gi);
  
  buf #(1) (Ci, Gi);
  
endmodule

module Square(output G, P, input Ai, Bi);
  
  and #(1) (G, Ai, Bi);
  xor #(2) (P, Ai, Bi);
  
endmodule

module Triangle(output Si, input Pi, CiPrev);
  
  xor #(2) (Si, Pi, CiPrev);
  
endmodule

module tt_um_koggestone_adder8(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset                    
                        
    );

  wire [7:0] a = ui_in;
  wire [7:0] b = uio_in; 
  wire carry_out;
  wire [7:0] sum = uo_out; 

  //default values
  assign uio_oe = 8'b00000000;
  assign uio_out = 8'b00000000;
  assign ena = 1'b0; 
  assign clk = 1'b0; 
  assign rst_n = 1'b0; 

  
  wire cin = 1'b0;
  wire [7:0] c;
  wire [7:0] g, p;
  Square sq[7:0](g, p, a, b);

  // first line of circles
  wire [7:1] g2, p2;
  SmallCircle sc0_0(c[0], g[0]);
  BigCircle bc0[7:1](g2[7:1], p2[7:1], g[7:1], p[7:1], g[6:0], p[6:0]);
  
  // second line of circle
  wire [7:3] g3, p3;
  SmallCircle sc1[2:1](c[2:1], g2[2:1]);
  BigCircle bc1[7:3](g3[7:3], p3[7:3], g2[7:3], p2[7:3], g2[5:1], p2[5:1]);
    
  // third line of circle
  wire [7:7] g4, p4;
  SmallCircle sc2[6:3](c[6:3], g3[6:3]);
  BigCircle bc2_7(g4[7], p4[7], g3[7], p3[7], g3[3], p3[3]);

  // fourth line of circle
  SmallCircle sc3_7(c[7], g4[7]);

  // last line - triangles
  Triangle tr0(sum[0], p[0], cin);
  Triangle tr[7:1](sum[7:1], p[7:1], c[6:0]);
  
  // generate cout
  buf #(1) (cout, c[7]);
  
endmodule

