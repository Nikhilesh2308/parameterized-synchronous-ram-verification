# Parameterized Synchronous RAM Verification

A Verilog project for a parameterized synchronous RAM and a testbench covering front-door (FD) and back-door (BD) memory access combinations.

## Objectives

- Design a synchronous RAM with configurable data width and depth.
- Verify memory behavior through normal interface transactions (front-door access).
- Exercise controlled testbench-side memory access (back-door access).
- Explore memory initialization and file-based data handling with `$readmemh` and `$writememh`.
- Use plusargs where supported to select test options or file names.

## Access scenarios

The test plan covers these four combinations:

1. **FD Write → FD Read:** Write through the RAM interface and read through the interface.
2. **BD Write → BD Read:** Write and read through testbench back-door access.
3. **BD Write → FD Read:** Initialize or modify memory through back-door access, then read through the interface.
4. **FD Write → BD Read:** Write through the interface, then inspect memory through back-door access.

## Repository layout

```text
.
├── rtl/       # Parameterized RAM RTL
├── tb/        # Testbench and access tasks
├── sim/       # Run scripts and memory initialization data
└── README.md
```

## Run online with EDA Playground

1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select Verilog/SystemVerilog and a supported simulator.
3. Paste the RAM RTL into the Design pane and the testbench into the Testbench pane.
4. If the test uses an initialization file, add it using the playground's supported file options or initialize the memory in the testbench.
5. Click **Run** and review the transcript. Enable EPWave to inspect waveforms.

**Compatibility note:** EDA Playground does not automatically execute a local `run.sh` script. External file paths and command-line plusargs may need adapting to the selected simulator and playground settings.

## Run locally with Icarus Verilog

After the source files are added, a typical command is:

```bash
iverilog -g2012 -o sim.out rtl/*.v tb/*.v
vvp sim.out
```

If the testbench uses plusargs, pass them to `vvp`, for example:

```bash
vvp sim.out +MEMFILE=sim/init.hex
```

The plusarg name must match the one read by the testbench.

## Verification checklist

- [ ] Confirm synchronous read/write timing.
- [ ] Check address and data boundaries.
- [ ] Run all four FD/BD access combinations.
- [ ] Check initialization-file behavior.
- [ ] Confirm expected data and report mismatches.
- [ ] Record actual simulator output and results.

## Status

**Documentation scaffold:** Update this section after adding the RTL and testbench and running the tests. Do not report passing results until they have been observed in a simulator.

## Skills demonstrated

Verilog HDL, parameterized memory design, testbench tasks, front-door/back-door verification concepts, file-based memory initialization, simulator arguments, functional checking.

## License

Choose a license before distributing or reusing this project.
