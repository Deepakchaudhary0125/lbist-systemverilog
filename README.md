# LBIST — Logic Built-In Self-Test in SystemVerilog

A complete **Logic Built-In Self-Test (LBIST)** architecture designed and verified in SystemVerilog for a small combinational circuit. Achieves **100% stuck-at fault coverage** using an LFSR pattern generator and MISR response analyzer.

---

## Key Results

- **100% stuck-at fault coverage** (28/28 faults detected)
- **12/12 hand-modeled faults** detected in simulation
- **15 LFSR patterns** — matched industrial tool baseline
- **~380 cells** after Yosys synthesis, 0 problems

---

**FSM:** `IDLE → RUN → EVAL → DONE`

See `docs/` for full block diagram, FSM state diagram, and MISR structure.

---

## Modules

| File | Role |
|------|------|
| `rtl/pattern_gen.sv`    | 4-bit maximal-length LFSR (TPG) |
| `rtl/cut.sv`            | Combinational CUT: `out = (i0·i1) + (i2·i3)` |
| `rtl/stuck_models.sv`   | RTL fault injection (12 stuck-at faults) |
| `rtl/MISR.sv`           | 13 × 4-bit signature registers (ORA) |
| `rtl/comparator.sv`     | Signature comparison + detection count |
| `rtl/controller.sv`     | BIST FSM sequencer |
| `rtl/scan_ff.sv`, `rtl/scan_reg.sv` | DFT scan infrastructure |
| `rtl/top.sv`            | BIST top-level integration |
| `tb/tb.sv`              | Self-checking testbench |

---

## Verification

- **Simulation:** Icarus Verilog — `pass = 1`, `coverage = 100%`
- **Synthesis:** Yosys — 3 NAND gates for CUT, ~380 cells for full BIST
- **Fault simulation:** AUCOHL/Fault (Docker) — 100% coverage
- **Cross-validation:** LFSR patterns matched industrial generator baseline

---

## Tools

SystemVerilog · Yosys · Icarus Verilog · GTKWave · AUCOHL/Fault · Docker

---

## Docs

- `BIST_Fault_Coverage.pdf` — Full technical report
- `BIST_Files.pdf` — File-by-file explanation
- `images` — Block diagram, FSM diagram, MISR structure

---

## License

MIT
