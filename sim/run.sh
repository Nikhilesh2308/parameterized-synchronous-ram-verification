#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -Wall -o build/ram_sim rtl/sync_ram.v tb/tb_sync_ram.v
vvp build/ram_sim +INIT_FILE=sim/init.hex +DUMP_FILE=build/ram_dump.hex
