`default_nettype none

module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
    wire e;
    assign e = Pi & GiPrev; 
    assign G = e | Gi; 
    assign P = Pi & PiPrev; 
endmodule

module SmallCircle(output Ci, input Gi);
    assign Ci = Gi; 
endmodule

module Square(output G, P, input Ai, Bi);
    assign G = Ai & Bi; 
    assign P = Ai ^ Bi; 
endmodule

module Triangle(output Si, input Pi, CiPrev);
    assign Si = Pi ^ CiPrev; 
endmodule

module tt_um_koggestone_adder8(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    wire [7:0] a = ui_in;
    wire [7:0] b = uio_in; 
    wire cout;
    wire [7:0] sum; 

    // Internal wires for the carry
    wire cin = 1'b0;
    wire [7:0] c;
    wire [7:0] g, p;

    // Default values for output enable and output paths
    assign uio_oe = 8'b00000000; // Change this as per your requirements
    assign uio_out = 8'b00000000; // This should be updated based on the operation

    Square sq[7:0](g, p, a, b);

    // First line of circles
    wire [7:1] g2, p2;
    SmallCircle sc0_0(c[0], g[0]);
    BigCircle bc0[7:1](g2[7:1], p2[7:1], g[7:1], p[7:1], g[6:0], p[6:0]);
    
    // Second line of circles
    wire [7:3] g3, p3;
    SmallCircle sc1[2:1](c[2:1], g2[2:1]);
    BigCircle bc1[7:3](g3[7:3], p3[7:3], g2[7:3], p2[7:3], g2[5:1], p2[5:1]);
        
    // Third line of circles
    wire [7:7] g4, p4;
    SmallCircle sc2[6:3](c[6:3], g3[6:3]);
    BigCircle bc2_7(g4[7], p4[7], g3[7], p3[7], g3[3], p3[3]);

    // Fourth line of circles
    SmallCircle sc3_7(c[7], g4[7]);

    // Last line - triangles
    Triangle tr0(sum[0], p[0], cin);
    Triangle tr[7:1](sum[7:1], p[7:1], c[6:0]);
    
    // Generate cout
    buf #(1) (cout, c[7]);

    // Assign sum to the output
    assign uo_out = sum; 

    // Ensure correct operation on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            uo_out <= 8'b00000000;
        end else if (ena) begin
            // Update the output when enabled
            uo_out <= sum;
        end
    end
endmodule
