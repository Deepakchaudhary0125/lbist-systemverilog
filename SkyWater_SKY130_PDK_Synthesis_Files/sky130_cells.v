// ============================================================
// Minimal SKY130 cell model for fault simulation
// Only includes cells used in cut_netlist_sky130.v
// ============================================================

// A22O: (A1 & A2) | (B1 & B2)
module sky130_fd_sc_hd__a22o_1 (
     input  A1,
     input  A2,
     input  B1,
     input  B2,
     output X
 );
     assign X = (A1 & A2) | (B1 & B2);
 endmodule