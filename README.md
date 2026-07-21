# RV32I Single-Cycle Processor (System-on-Chip)

A complete, synthesizable 32-bit RISC-V CPU designed from scratch in Verilog. This processor implements a single-cycle datapath and is capable of executing core arithmetic, memory, and branching instructions from the RV32I base integer instruction set. 

Recently expanded from a standalone core into a basic System-on-Chip (SoC), this design features Memory-Mapped I/O (MMIO) and has been physically validated on FPGA silicon.

## 🛠️ Architecture Overview
This core follows a classic single-cycle architecture. Every instruction is fetched, decoded, and executed within a single clock tick.

* **Instruction Set Architecture (ISA):** RISC-V (RV32I Base Integer)
* **Word Size:** 32-bit
* **Hardware Description Language:** Verilog (IEEE 1364-2005)
* **Target Hardware:** Gowin Tang Primer 25K (FPGA)

### Supported Instructions (Verified)
The current Control Unit and Datapath support the complete RV32I base integer instruction set (37 instructions):
* **R-Type (Register-Register):** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
* **I-Type (Register-Immediate):** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`
* **Load/Store Memory:** `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`
* **B-Type (Control Flow):** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
* **J-Type & U-Type (Jumps & Upper Immediates):** `jal`, `jalr`, `lui`, `auipc`

---

## 🔌 SoC & Peripheral Integration
To interface with external hardware, the base CPU was expanded to support a custom **UART Transmitter (TX)** peripheral.
* **MMIO Implementation:** The UART TX module is mapped directly to the core's memory interface, allowing the CPU to transmit data using standard `store` instructions.
* **Hardware/Software Co-Design:** Successfully executed a custom bare-metal assembly program that polls the UART's `tx_ready` status register to continuously transmit the string `"Rider\r\n"` to a serial terminal.

---

## ⚡ Hardware Prototyping & Silicon Validation
The complete RTL design (RV32I Core + UART TX) has been successfully synthesized and deployed to physical hardware to validate timing and logic gate utilization.

**Hardware Stack:** Gowin Tang Primer 25K FPGA

### Prototype Demonstration
*(Below is the serial output of the RISC-V core executing a memory-mapped assembly loop and transmitting characters via the physical UART TX pin)*

<video src="./docs/testing.mp4" width="600" controls></video>

### Board Setup & Logic Analysis
<div style="display: flex; gap: 10px;">
  <img src="./docs/FPGA.jpeg" alt="Setup" width="400"/>
  <img src="./docs/Terminal_result.jpeg" alt="Terminal Output" width="400"/>
</div>

---

## 🚀 Simulation & Verification
Prior to synthesis, the CPU was strictly verified using Vivado Behavioral Simulation. The verification environment utilizes a self-checking assembly program (`test.S`) that validates all 37 instructions sequentially. 

**Example Console Output (Self-Checking Testbench):**
```text
==================================================
         RISC-V CPU SIMULATION REPORT             
==================================================
 Time: 0 ns | PC: 00000000 | Instr: 00000513 
 Time: 5 ns | PC: 00000004 | Instr: 00500093 
 ...
==================================================
