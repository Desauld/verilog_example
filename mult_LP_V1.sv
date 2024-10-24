module mult_LP_V1 #(
  parameter W = 16
) (
  input                clk,
  input      [  W-1:0] dA,
  input      [  W-1:0] dB,
  output reg [2*W-1:0] a_mult_b
);

  reg [2*W-1:0] dSUM[0:W];
  reg [  W-1:0] A   [0:W];
  reg [  W-1:0] B   [0:W];

  initial begin
    for (int i = 0; i <= W; i++) begin
      dSUM[i] <= 1'b0;
      A[i]    <= 1'b0;
      B[i]    <= 1'b0;
    end
    a_mult_b <= 1'b0;
  end

  always @(posedge clk) begin
    A[0] <= dA;
    B[0] <= dB;
  end

  genvar i;
  generate
    for (i = 0; i < W; i++) begin : generator
      always @(posedge clk) begin
        dSUM[i+1] <= (dSUM[i] << 1'b1) + (B[i][W-i-1] ? A[i] : 1'b0);
        A[i+1]    <= A[i];
        B[i+1]    <= B[i];
      end
    end
  endgenerate

  always @(posedge clk) a_mult_b <= dSUM[W];

endmodule
