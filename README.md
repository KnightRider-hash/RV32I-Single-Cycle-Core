# RV32I Single-Cycle Processor

A complete, synthesizable 32-bit RISC-V CPU designed from scratch in Verilog. This processor implements a single-cycle datapath and is capable of executing core arithmetic, memory, and branching instructions from the RV32I base integer instruction set.

## 🛠️ Architecture Overview
This core follows a classic single-cycle architecture. Every instruction is fetched, decoded, and executed within a single clock tick.

* **Instruction Set Architecture (ISA):** RISC-V (RV32I Base Integer)
* **Word Size:** 32-bit
* **Hardware Description Language:** Verilog (IEEE 1364-2005)
* **Simulation & Verification:** Xilinx Vivado
* **Target Hardware:** Gowin Tang Primer 25K (FPGA)

### Supported Instructions
The current Control Unit and Datapath support the following operations:
* **Arithmetic/Logic:** `ADD`, `ADDI`
* **Memory Access:** `LW` (Load Word), `SW` (Store Word)
* **Control Flow:** `BEQ` (Branch if Equal)

## 📂 Repository Structure
* `/Src`: Core Verilog modules (ALU, Control Unit, Register File, PC, Data RAM).
* `/Sim`: Testbenches and hexadecimal instruction files for behavioral simulation.
* `/Docs`: Architecture diagrams and waveform verifications.

## 🚀 Simulation & Verification
The CPU has been strictly verified using Vivado Behavioral Simulation. The test suite includes self-checking testbenches that validate register states, memory read/writes, and branch logic.

![Waveform Screenshot](./Docs/waveform.png) 

**Example Console Output (Arithmetic Validation):**
```text
==================================================
          RISC-V CPU SIMULATION REPORT            
==================================================
 TIME         : 110 ns
 Instruction 1: ADDI x11, x0, 5  -> x11 = 5
 Instruction 2: ADDI x12, x0, 6  -> x12 = 6
--------------------------------------------------
 Instruction 3: ADD  x13, x11, x12 -> x13 = 11 (SUM)
==================================================
