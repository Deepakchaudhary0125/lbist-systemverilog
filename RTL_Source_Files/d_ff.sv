`ifndef D_FF_SV
`define D_FF_SV

module d_ff (
  input  logic clk,
  input  logic rstn,
  input  logic din,
  output logic q
);

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn)
      q <= 1'b0;
    else
      q <= din;
  end

endmodule

`endif