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
The current Control Unit and Datapath support the complete RV32I base integer instruction set (37 instructions):
* **R-Type (Register-Register):** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
* **I-Type (Register-Immediate):** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`
* **Load/Store Memory:** `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`
* **B-Type (Control Flow):** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
* **J-Type & U-Type (Jumps & Upper Immediates):** `jal`, `jalr`, `lui`, `auipc`

## 🚀 Simulation & Verification
The CPU has been strictly verified using Vivado Behavioral Simulation. The verification environment utilizes a self-checking assembly program (`test.S`) that validates all 37 instructions sequentially. If an arithmetic or branching error occurs, the processor traps and reports the failed test number via a status register.

![Waveform Screenshot](./Docs/waveform.png) 

**Example Console Output (Self-Checking Testbench):**
```text
==================================================
         RISC-V CPU SIMULATION REPORT             
==================================================
 Time: 0 ns | PC: 00000000 | Instr: 00000513 
 Time: 5 ns | PC: 00000004 | Instr: 00500093 
 ...
==================================================

==================================================

