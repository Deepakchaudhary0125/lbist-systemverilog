# LBIST — Logic Built-In Self-Test in SystemVerilog

A complete **Logic Built-In Self-Test (LBIST)** architecture designed, verified, and synthesized to a real PDK — all in open-source tooling. Achieves **100% stuck-at fault coverage** across every stage: RTL simulation, generic gate netlist, and SkyWater SKY130 standard-cell netlist.

---

## Key Results

### Fault Coverage — 100% at Every Stage

| # | Netlist | Pattern Source | Fault Sites | Coverage |
|---|---------|---------------|-------------|----------|
| 1 | RTL simulation | Hand-modeled (12) | 12 | **100%** |
| 2 | Generic Yosys | AUCOHL/Fault internal | 14 | **100%** |
| 3 | Generic Yosys | LFSR (15 patterns) | 14 | **100%** |
| 4 | SKY130 PDK | AUCOHL/Fault internal | 10 | **100%** |
| 5 | SKY130 PDK | LFSR (15 patterns) | 10 | **100%** |

### Synthesis Evolution

| Stage | Library | Cells | Notes |
|-------|---------|-------|-------|
| Generic | `$_NAND_` | 3 | CUT only |
| Generic | Yosys primitives | ~380 | Full BIST |
| **SKY130 PDK** | `sky130_fd_sc_hd` | **1** | CUT → single A22O cell |
| **SKY130 PDK** | `sky130_fd_sc_hd` | **348** | Full BIST, **3905 µm²** |

### SKY130 PDK Synthesis Highlights

- **348 standard cells** from SkyWater 130nm high-density library
- **3905 µm²** total chip area (47% sequential, 53% combinational)
- **73 flip-flops** (58 `dfrtp_1` + 15 `dfstp_1`)
- **21 distinct cell types** — realistic ASIC netlist
- **Tapeout-ready** — compatible with OpenROAD / OpenLane physical design flows

---


**FSM:** `IDLE → RUN → EVAL → DONE`

See `.png` files for block diagram, FSM state diagram, and MISR structure.

---

## Modules

| File | Role |
|------|------|
| `rtl/pattern_gen.sv`    | 4-bit maximal-length LFSR (TPG), taps `out[3]⊕out[0]` |
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

- **RTL simulation:** Icarus Verilog → `pass = 1`, `coverage = 100%`
- **Generic synthesis:** Yosys → 3 NAND gates for CUT, ~380 cells for full BIST
- **Fault simulation:** AUCOHL/Fault (Docker) → **100% coverage**
- **SKY130 synthesis:** Yosys + Liberty → **348 cells, 3905 µm²**
- **SKY130 fault simulation:** AUCOHL/Fault → **100% coverage**
- **Cross-validation:** LFSR patterns matched industrial generator baseline on both netlists

---

## Tools

SystemVerilog · Yosys · Icarus Verilog · GTKWave · AUCOHL/Fault · Docker · **SkyWater SKY130 PDK**

---

## Docs

- `docs/LBIST_Fault_Coverage(3in1).pdf` — Full technical report
- `docs/LBIST_Files.pdf` — File-by-file explanation
- `.png` files — Block diagram, FSM diagram, MISR structure
- `RESULTS_SUMMARY.md` — Quick-reference results table

---

## License

MIT
