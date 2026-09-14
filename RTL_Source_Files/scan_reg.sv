`ifndef SCAN_REG_SV
`define SCAN_REG_SV

`include "scan_ff.sv"

module scan_chain #(
  parameter int REG_SIZE = 4
)(
  input  logic                clk,
  input  logic                rstn,
  input  logic                shift_en,
  input  logic                capture_en,
  input  logic                TDI,
  output logic                TDO,
  input  logic [REG_SIZE-1:0] din,
  output logic [REG_SIZE-1:0] q
);

  logic [REG_SIZE:0] scan_wire;

  // Serial input
  assign scan_wire[0] = TDI;

  // Serial output
  assign TDO = scan_wire[REG_SIZE];

  genvar i;

  generate
    for (i = 0; i < REG_SIZE; i++) begin : gen_sff

      scan_ff sff (
        .clk (clk),
        .rstn(rstn),
        .din (din[i]),
        .shift_en(shift_en),
        .capture_en(capture_en),
        .TDI (scan_wire[i]),
        .TDO (scan_wire[i+1]),
        .q   (q[i])
      );

    end
  endgenerate

endmodule

`endif