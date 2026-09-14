`ifndef SCAN_FF_SV
`define SCAN_FF_SV

`include "d_ff.sv"

module scan_ff (
  input  logic clk,
  input  logic rstn,

  input  logic din,

  input  logic shift_en,
  input  logic capture_en,

  input  logic TDI,
  output logic TDO,

  output logic q
);

  logic d_in;

  always_comb begin

    if (shift_en)
      d_in = TDI;

    else if (capture_en)
      d_in = din;

    else
      d_in = q;       // HOLD

  end

  assign TDO = q;

  d_ff df (
    .clk (clk),
    .rstn(rstn),
    .din (d_in),
    .q   (q)
  );

endmodule

`endif