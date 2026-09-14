`timescale 1ns/1ps
`include "top.sv"
module bist_tb;

    parameter int REG_WIDTH    = 4;
    parameter int NUM_PATTERNS = 15;
    parameter int TOTAL_FAULTS = 12;

    logic                 rstn, clk;
    logic                 start_ext;
    logic [REG_WIDTH-1:0] smodel;
    logic [REG_WIDTH-1:0] out_pattern;
    logic                 cut_out;
    logic                 done, pass;
    logic [6:0]           coverage;
    logic [3:0]           num_detected;

    bist_top #(
        .REG_WIDTH    (REG_WIDTH),
        .NUM_PATTERNS (NUM_PATTERNS),
        .TOTAL_FAULTS (TOTAL_FAULTS)
    ) uut (
        .clk          (clk),
        .rstn         (rstn),
        .start_ext    (start_ext),
        .smodel       (smodel),
        .out_pattern  (out_pattern),
        .cut_out      (cut_out),
        .done         (done),
        .pass         (pass),
        .coverage     (coverage),
        .num_detected (num_detected)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    int detected_count;
    int f;

    initial begin
        rstn      = 0;
        start_ext = 0;
        smodel    = '0;
        detected_count = 0;

        #20;
        rstn = 1;
        #10;

        $display("\n====================================");
        $display("        BIST Test Start");
        $display("====================================");

        for (f = 0; f < TOTAL_FAULTS; f++) begin
            smodel = f[REG_WIDTH-1:0];

            rstn      = 0;
            start_ext = 0;
            @(posedge clk);
            @(posedge clk);
            rstn = 1;
            @(posedge clk);

            start_ext = 1;
            @(posedge clk);
            start_ext = 0;

            wait (done == 1);
            #1;

            if (pass) detected_count++;

            $display("fault %0d (smodel=%0d): %s  (out_pattern=%04b, cut_out=%b, num_detected=%0d)",
                      f, smodel, pass ? "DETECTED" : "MISSED", out_pattern, cut_out, num_detected);
        end

        $display("\n============================================");
        $display("           BIST TEST DONE");
        $display("============================================");
        $display("faults detected = %0d / %0d", detected_count, TOTAL_FAULTS);
        $display("pass            = %b",        (detected_count == TOTAL_FAULTS));
        $display("coverage        = %0d%%",     (detected_count * 100) / TOTAL_FAULTS);
        $display("============================================\n");

        repeat(5) @(posedge clk);
        $finish;
    end

    // ---- Timeout safety ----
    initial begin
        #10000;
        $display("ERROR: Test timed out — done never asserted.");
        $finish;
    end

    // ---- Waveform ----
    initial begin
        $dumpfile("bist.vcd");
        $dumpvars(0, bist_tb);
    end

endmodule