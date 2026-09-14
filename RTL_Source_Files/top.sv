`include "pattern_gen.sv"
`include "stuck_models.sv"
`include "cut.sv"
`include "MISR.sv"
`include "comparator.sv"
`include "controller.sv"
`include "scan_reg.sv"

module bist_top #(
    parameter int REG_WIDTH    = 4,

    parameter int NUM_PATTERNS = 15,
    parameter int TOTAL_FAULTS = 12
)(
    input  logic                    rstn, clk,
    input  logic                    start_ext,
    input  logic [REG_WIDTH-1:0]    smodel,

    output logic [REG_WIDTH-1:0]    out_pattern,
    output logic                    cut_out,
    output logic                    done, pass,
    output logic [6:0]              coverage,
    output logic [3:0]              num_detected
);

    // ---- Fault model signals ----
    logic F_at_A, F_at_Abar,
          F_at_B, F_at_Bbar,
          F_at_C, F_at_Cbar,
          F_at_D, F_at_Dbar,
          F_at_X, F_at_Xbar,
          F_at_Y, F_at_Ybar,
          GoodF;

    // ---- MISR signatures ----
    logic [REG_WIDTH-1:0] Sign_F_at_A, Sign_F_at_Abar,
                          Sign_F_at_B, Sign_F_at_Bbar,
                          Sign_F_at_C, Sign_F_at_Cbar,
                          Sign_F_at_D, Sign_F_at_Dbar,
                          Sign_F_at_X, Sign_F_at_Xbar,
                          Sign_F_at_Y, Sign_F_at_Ybar,
                          Sign_Good;

    // ---- Comparator detection flags ----
    logic Det_A, Det_Abar,
          Det_B, Det_Bbar,
          Det_C, Det_Cbar,
          Det_D, Det_Dbar,
          Det_X, Det_Xbar,
          Det_Y, Det_Ybar;

    // ---- Controller outputs ----
    logic start;                     // to LFSR
    logic scan_en, capture_en;       

    // logic TDI,TDO;


    // scan_chain #(.REG_SIZE(REG_WIDTH)) uut_schain(
    //   .clk(clk),
    //   .rstn(rstn),
    //   .shift_en(shift_en),
    //   .capture_en(capture_en),
    //   .TDI(),
    //   .TDO(TDO),
    //   .din('0),
    //   .q(out_pattern)

    // );

    // ---- CUT ----
    cut u_cut (
        .in  (out_pattern),
        .out (cut_out)
    );

    // ---- Fault models ----
    stuck_at_models #(.REG_WIDTH(REG_WIDTH))
      uut_model (
        .in       (out_pattern),
        .smodel   (smodel),
        .GoodF    (GoodF),
        .F_at_A   (F_at_A),   .F_at_Abar(F_at_Abar),
        .F_at_B   (F_at_B),   .F_at_Bbar(F_at_Bbar),
        .F_at_C   (F_at_C),   .F_at_Cbar(F_at_Cbar),
        .F_at_D   (F_at_D),   .F_at_Dbar(F_at_Dbar),
        .F_at_X   (F_at_X),   .F_at_Xbar(F_at_Xbar),
        .F_at_Y   (F_at_Y),   .F_at_Ybar(F_at_Ybar)
      );

    // ---- LFSR ----
    pattern_lfsr #(.REG_WIDTH(REG_WIDTH))
      uut_pattern (
        .clk   (clk),
        .rstn  (rstn),
        .start (start),
        .out   (out_pattern)
      );

    // ---- MISR ----
    MISR #(.REG_WIDTH(REG_WIDTH))
      uut_misr (
        .clk  (clk),
        .rstn (rstn),
        .en   (start),
        .smodel(smodel),
        .F_at_A   (F_at_A),   .F_at_Abar(F_at_Abar),
        .F_at_B   (F_at_B),   .F_at_Bbar(F_at_Bbar),
        .F_at_C   (F_at_C),   .F_at_Cbar(F_at_Cbar),
        .F_at_D   (F_at_D),   .F_at_Dbar(F_at_Dbar),
        .F_at_X   (F_at_X),   .F_at_Xbar(F_at_Xbar),
        .F_at_Y   (F_at_Y),   .F_at_Ybar(F_at_Ybar),
        .GoodF    (GoodF),

        .Sign_F_at_A     (Sign_F_at_A),     .Sign_F_at_Abar(Sign_F_at_Abar),
        .Sign_F_at_B     (Sign_F_at_B),     .Sign_F_at_Bbar(Sign_F_at_Bbar),
        .Sign_F_at_C     (Sign_F_at_C),     .Sign_F_at_Cbar(Sign_F_at_Cbar),
        .Sign_F_at_D     (Sign_F_at_D),     .Sign_F_at_Dbar(Sign_F_at_Dbar),
        .Sign_F_at_X     (Sign_F_at_X),     .Sign_F_at_Xbar(Sign_F_at_Xbar),
        .Sign_F_at_Y     (Sign_F_at_Y),     .Sign_F_at_Ybar(Sign_F_at_Ybar),
        .Sign_Good       (Sign_Good)
      );

    // ---- Comparator ----
    comparator #(.REG_WIDTH(REG_WIDTH))
      uut_comp (
        .clk  (clk),
        .rstn (rstn),
        .Sign_Good(Sign_Good),
        .Sign_F_at_A     (Sign_F_at_A),     .Sign_F_at_Abar(Sign_F_at_Abar),
        .Sign_F_at_B     (Sign_F_at_B),     .Sign_F_at_Bbar(Sign_F_at_Bbar),
        .Sign_F_at_C     (Sign_F_at_C),     .Sign_F_at_Cbar(Sign_F_at_Cbar),
        .Sign_F_at_D     (Sign_F_at_D),     .Sign_F_at_Dbar(Sign_F_at_Dbar),
        .Sign_F_at_X     (Sign_F_at_X),     .Sign_F_at_Xbar(Sign_F_at_Xbar),
        .Sign_F_at_Y     (Sign_F_at_Y),     .Sign_F_at_Ybar(Sign_F_at_Ybar),
        .Det_A   (Det_A),   .Det_Abar(Det_Abar),
        .Det_B   (Det_B),   .Det_Bbar(Det_Bbar),
        .Det_C   (Det_C),   .Det_Cbar(Det_Cbar),
        .Det_D   (Det_D),   .Det_Dbar(Det_Dbar),
        .Det_X   (Det_X),   .Det_Xbar(Det_Xbar),
        .Det_Y   (Det_Y),   .Det_Ybar(Det_Ybar),
        .num_detected(num_detected)
      );

    // ---- Controller ----
    controller #(
        .NUM_PATTERNS (NUM_PATTERNS),
        .TOTAL_FAULTS (TOTAL_FAULTS)
    )
    uut_controller (
        .clk          (clk),
        .rstn         (rstn),
        .start_ext    (start_ext),
        .num_detected (num_detected),
        .start        (start),
        .scan_en      (scan_en),
        .capture_en   (capture_en),
        .done         (done),
        .pass         (pass),
        .coverage     (coverage)
    );

endmodule