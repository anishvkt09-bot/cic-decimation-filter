# 4-Stage Cascaded Integrator-Comb (CIC) Decimation Filter

A hardware-efficient, multiplierless 4-stage CIC decimation filter implemented in Verilog for digital downsampling.

## Architecture & Parameters
* **Filter Order ($N$):** 4 Stages
* **Decimation Factor ($R$):** 512
* **Differential Delay ($M$):** 1
* **Input Resolution:** 1-bit / multi-bit stream
* **Internal Word Length:** 38-bit precision
* **Output Interface:** 20-bit MSB truncation (`[37:18]`) for passband gain normalization.

## Module Hierarchy
* `top_module.v`: Top-level integration connecting integrator stages, decimation clock/enable control, and comb differentiators.
* `integrator.v`: Discrete-time accumulator stages operating at the high sampling rate ($f_s$).
* `comb.v`: Differentiator stages operating at the decimated rate ($f_s / R$).
* `counter.v`: Downsampling control generating the decimated clock/strobe (`outready`).
* `tb.v`: Generalized behavioral simulation testbench verifying response across passband, transition, and alias frequencies (10 Hz, 500 Hz, 990 Hz).

## Verification
* Simulated using AMD Vivado Design Suite.
* this design utilizes exclusively additions, subtractions, and registers—eliminating dedicated FPGA DSP block consumption.
