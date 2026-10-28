# Parameterized Synchronous RAM Verification

Parameterized synchronous single-port RAM with a testbench demonstrating front-door (FD) and back-door (BD) memory access scenarios.

## Features
- Configurable data width, address width, and depth.
- Synchronous front-door read/write.
- Testbench-side back-door memory access for simulation.
- Four FD/BD access combinations.
- VCD waveform dumping.

## Files
- `rtl/sync_ram.v` — parameterized synchronous RAM RTL.
- `tb/tb_sync_ram.v` — testbench with FD/BD access checks.
- `sim/init.hex` — example initialization data for future file-based initialization exercises.
- `sim/run.sh` — local Icarus Verilog compile/run script.

## Access scenarios
1. FD Write → FD Read.
2. BD Write → BD Read.
3. BD Write → FD Read.
4. FD Write → BD Read.

## Run locally
Install Icarus Verilog, then run from the repository root:

```bash
bash sim/run.sh
```

Review the output for the PASS checks and final `RAM test summary`. Run it yourself and confirm `FAIL=0` before reporting the project as verified.

## Run on EDA Playground
1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select Verilog and a supported simulator.
3. Paste `rtl/sync_ram.v` into the Design pane.
4. Paste `tb/tb_sync_ram.v` into the Testbench pane.
5. Run and inspect the transcript. Enable EPWave for waveforms if desired.

## Notes
Back-door access via `dut.mem[index]` is a simulation testbench technique, not a synthesizable interface. The example `sim/init.hex` file is included for a follow-on exercise; the current testbench writes memory directly and does not consume that file.

## Verification status
Source and testbench have been added. Simulation results have not been independently confirmed in this repository yet.

## Skills
Verilog HDL, parameterized memories, testbench tasks, front-door/back-door access, simulation-based functional verification.
