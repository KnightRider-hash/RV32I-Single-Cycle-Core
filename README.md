# RV32I Single-Cycle Processor (System-on-Chip)

A complete, synthesizable 32-bit RISC-V CPU designed from scratch in Verilog. This processor implements a single-cycle datapath and is capable of executing core arithmetic, memory, and branching instructions from the RV32I base integer instruction set. 

Recently expanded from a standalone core into a basic System-on-Chip (SoC), this design features Memory-Mapped I/O (MMIO) and has been physically validated on FPGA silicon.

## 🛠️ Architecture Overview
This core follows a classic single-cycle architecture. Every instruction is fetched, decoded, and executed within a single clock tick.

* **Instruction Set Architecture (ISA):** RISC-V (RV32I Base Integer)
* **Word Size:** 32-bit
* **Hardware Description Language:** Verilog (IEEE 1364-2005)
* **Target Hardware:** Gowin Tang Primer 25K (FPGA)

### Supported Instructions (In Verification Phase)
The current Control Unit and Datapath are designed to support the complete RV32I base integer instruction set (37 instructions). **Verification is currently ongoing, with 7 major instructions fully verified in simulation and hardware so far.**

The full planned instruction set being actively verified includes:
* **R-Type (Register-Register):** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
* **I-Type (Register-Immediate):** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`
* **Load/Store Memory:** `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`
* **B-Type (Control Flow):** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
* **J-Type & U-Type (Jumps & Upper Immediates):** `jal`, `jalr`, `lui`, `auipc`

---

## 🔌 SoC & Peripheral Integration
To interface with external hardware, the base CPU was expanded to support a custom **Universal Asynchronous Receiver-Transmitter (UART)** peripheral.
* **MMIO Implementation:** The UART is mapped directly to the core's memory interface, allowing the CPU to transmit data using standard `store` instructions.
* **Hardware/Software Co-Design:** Successfully executed a custom bare-metal assembly program that polls the UART's `tx_ready` status register to continuously transmit the string `"Rider\r\n"` to a serial terminal.

---

## ⚡ Hardware Prototyping & Silicon Validation
The complete RTL design (RV32I Core + UART) has been successfully synthesized and deployed to physical hardware to validate timing and logic gate utilization.

**Hardware Stack:** Gowin Tang Primer 25K FPGA

### Prototype Demonstration
*(Below is the serial output of the RISC-V core executing a memory-mapped assembly loop and transmitting characters via the physical UART TX pin)*



https://github.com/user-attachments/assets/e4011dca-f055-400e-b63b-c8553ec0df20



## 🚀 Simulation & Verification
Prior to synthesis, the CPU is being strictly verified using Vivado Behavioral Simulation. The verification environment utilizes a self-checking assembly program (`test.S`) to validate instructions. Currently, all instructions are undergoing testing, with major instructions fully verified. 


**Example Console Output (Self-Checking Testbench):**
```text
==================================================
         RISC-V CPU SIMULATION REPORT             
==================================================
 Time: 0 ns | PC: 00000000 | Instr: 00000513 
 Time: 5 ns | PC: 00000004 | Instr: 00500093 
 Time: 10 ns | PC: 00000008 | Instr: 00500113 
 Time: 15 ns | PC: 0000000C | Instr: 02209463 
 Time: 20 ns | PC: 00000010 | Instr: 002081B3 
 Time: 25 ns | PC: 00000014 | Instr: 00A00213 
 Time: 30 ns | PC: 00000018 | Instr: 02419263 
 Time: 35 ns | PC: 0000001C | Instr: 00100293 
 Time: 40 ns | PC: 00000020 | Instr: 00429313 
 Time: 45 ns | PC: 00000024 | Instr: 01000393 
 Time: 50 ns | PC: 00000028 | Instr: 00731E63 
 Time: 55 ns | PC: 0000002C | Instr: 3E700513 
 Time: 60 ns | PC: 00000030 | Instr: 01C0006F 
 Time: 65 ns | PC: 00000034 | Instr: 00100513 
 Time: 70 ns | PC: 00000038 | Instr: 0140006F 
 Time: 75 ns | PC: 0000003C | Instr: 00200513 
 Time: 80 ns | PC: 00000040 | Instr: 00C0006F 
 Time: 85 ns | PC: 00000044 | Instr: 00300513 
 Time: 90 ns | PC: 00000048 | Instr: 0040006F 
 Time: 95 ns | PC: 0000004C | Instr: 0000006F 
==================================================
