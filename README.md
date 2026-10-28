# Parameterized Synchronous RAM Verification

**Portfolio project:** PRJ_06 — Memory Verification  
**Language:** Verilog-2001  
**Verification focus:** Front-door (FD) and back-door (BD) access

## Objective
Verify a parameterized synchronous single-port RAM using normal RTL interface transactions and simulation-only hierarchical memory access.

## Repository layout
```text
rtl/
  sync_ram.v       # parameterized synchronous RAM
tb/
  tb_sync_ram.v    # reusable FD/BD tasks and self-checking scenarios
sim/
  init.hex         # optional memory initialization data
  run.sh           # compile and run with Icarus Verilog
.gitignore
README.md
```

## RTL parameters and interface
- `DATA_WIDTH`: memory word width (default 8 bits).
- `ADDR_WIDTH`: address width (default 4 bits).
- `DEPTH`: number of words (default `2**ADDR_WIDTH`).
- `en`, `we`, `addr`, `wdata`, `rdata`: synchronous single-port interface.

## Verification scenarios
1. **FD Write → FD Read** — write through the RAM ports and read back through the ports.
2. **BD Write → BD Read** — write and inspect the internal memory array hierarchically.
3. **BD Write → FD Read** — update the internal array, then verify using a normal RTL read.
4. **FD Write → BD Read** — write through the RTL interface, then inspect the stored word.

The testbench uses tasks for repeatable operations and compares actual values with expected values.

## File-based initialization, runtime arguments, and memory dump
The testbench supports:
- `+INIT_FILE=sim/init.hex` — load initial memory contents with `$readmemh`.
- `+DUMP_FILE=build/ram_dump.hex` — save memory contents with `$writememh`.

The local script supplies both arguments. If running on EDA Playground, add the contents of `sim/init.hex` as a separate file if you want to test initialization, and set the runtime arguments if the simulator interface supports them. The four FD/BD checks do not depend on initialization.

## Run locally with Icarus Verilog
From the repository root:

```bash
bash sim/run.sh
```

The script compiles the RTL and testbench, runs the simulation, and writes a VCD file plus a memory dump under `build/`.

## Run on EDA Playground
1. Select Verilog and Icarus Verilog.
2. Paste `rtl/sync_ram.v` in the Design pane.
3. Paste `tb/tb_sync_ram.v` in the Testbench pane.
4. Run the testbench. If runtime plusargs are available, use `+INIT_FILE=init.hex +DUMP_FILE=ram_dump.hex`.
5. Open EPWave and click **Get Signals** to select the clock, control, address, data, and memory-related signals.

## Verification status
The testbench and run flow are committed. Run this project and confirm `FAIL=0` before describing its simulation as passing. The current verified EDA Playground result in the portfolio conversation applies to PRJ_05 (APB), not this RAM project.

## Scope and limitations
Back-door access through `dut.mem[index]` is a simulation-only verification technique, not a synthesizable hardware interface. This project is a learning/portfolio exercise and does not claim UVM-based verification or measured functional/code coverage.

## Skills demonstrated
Parameterized RTL, synchronous RAM behavior, testbench tasks, front-door/back-door access, `$readmemh`, `$writememh`, plusargs, self-checking verification, and waveform inspection.
