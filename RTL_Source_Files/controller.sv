`timescale 1ns/1ps

module controller #(
    parameter int NUM_PATTERNS = 15,     // 4-bit maximal LFSR period
    parameter int TOTAL_FAULTS = 12
)(
    input  logic       clk,
    input  logic       rstn,

    // External trigger
    input  logic       start_ext,        // external "go" signal

    // From comparator
    input  logic [3:0] num_detected,

    // To LFSR
    output logic       start,            // drives pattern_lfsr.start

    // To scan chain
    output logic       scan_en,
    output logic       capture_en,

    // Status outputs
    output logic       done,
    output logic       pass,
    output logic [6:0] coverage          // 0..100
);


    typedef enum logic [1:0] {
        IDLE,RUN,EVAL,DONE 
    } state_t;

    state_t state, next_state;

    // ---- Internal registers ----
    logic [4:0] cycle_cnt;               // counts up to NUM_PATTERNS
    logic       pass_reg;
    logic [6:0] coverage_reg;

    always_comb begin
      
        next_state  = state;
        start       = 1'b0;
        scan_en     = 1'b0;
        capture_en  = 1'b0;
        done        = 1'b0;

        case (state)

            // ------------------------------------------------
            IDLE: begin
                start      = 1'b0;
                scan_en    = 1'b0;
                capture_en = 1'b0;
                done       = 1'b0;

                if (start_ext)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end

            // ------------------------------------------------
            RUN: begin
                start      = 1'b1;       // enable LFSR
                scan_en    = 1'b0;
                capture_en = 1'b0;
                done       = 1'b0;

                if (cycle_cnt == NUM_PATTERNS - 1)
                    next_state = EVAL;
                else
                    next_state = RUN;
            end

            // ------------------------------------------------
            EVAL: begin
                start      = 1'b0;       // freeze LFSR
                scan_en    = 1'b0;
                capture_en = 1'b1;       // capture signature into scan chain
                done       = 1'b0;

                next_state = DONE;       // 1 cycle in EVAL
            end

            // ------------------------------------------------
            DONE: begin
                start      = 1'b0;
                scan_en    = 1'b1;       // shift out signature
                capture_en = 1'b0;
                done       = 1'b1;       // signal completion

                if (start_ext)
                    next_state = RUN;    // re-run if asked
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;

        endcase
    end

    // ============================================================
    //  SEQUENTIAL BLOCK
    // ============================================================
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state        <= IDLE;
            cycle_cnt    <= '0;
            pass_reg     <= 1'b0;
            coverage_reg <= 7'd0;
        end
        else begin
            state <= next_state;

            // ---- cycle counter ----
            case (state)
                IDLE: cycle_cnt <= '0;

                RUN: begin
                    if (cycle_cnt == NUM_PATTERNS - 1)
                        cycle_cnt <= '0;     // reset for next run
                    else
                        cycle_cnt <= cycle_cnt + 1'b1;
                end

                EVAL: cycle_cnt <= cycle_cnt;  // hold (only 1 cycle in EVAL, doesn't matter)

                DONE: cycle_cnt <= '0;         
            endcase


            if (state == EVAL) begin
                pass_reg     <= (num_detected != '0);
                coverage_reg <= (num_detected * 100) / TOTAL_FAULTS;
            end
        end
    end

    // ---- Registered outputs (glitch-free) ----
    assign pass     = pass_reg;
    assign coverage = coverage_reg;

endmodule