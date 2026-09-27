# RV32I Single-Cycle Processor (System-on-Chip)

A complete, synthesizable 32-bit RISC-V CPU designed from scratch in Verilog. This processor implements a single-cycle datapath capable of executing the complete unprivileged RV32I base integer instruction set.

Expanded from a standalone core into a custom System-on-Chip (SoC), this design features Memory-Mapped I/O (MMIO) and has been comprehensively verified in RTL simulation before physical validation on FPGA silicon.

---

## 🛠️ Architecture Overview

This core follows a classic single-cycle architecture. Every instruction is fetched, decoded, executed, and written back within a single clock tick.

| | |
|---|---|
| **Instruction Set Architecture (ISA)** | RISC-V (RV32I Base Integer) |
| **Word Size** | 32-bit |
| **Hardware Description Language** | Verilog (IEEE 1364-2005) |
| **Target Hardware** | Sipeed Tang Primer 25K (Gowin GW5A) |
| **Toolchain** | Icarus Verilog, GTKWave, Gowin EDA |

---

## 📜 Supported Instruction Set (Fully Verified)

The Control Unit and Datapath completely support the unprivileged RV32I base integer instruction set (37 distinct instructions). All instructions have successfully passed strict behavioral simulation testing edge cases like sub-word memory masking, unsigned branch evaluation, and arithmetic sign-extension.

- **R-Type (Register-Register):** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
- **I-Type (Register-Immediate):** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`
- **Load/Store Memory:** `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`
- **B-Type (Control Flow):** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- **J-Type & U-Type (Jumps & Upper Immediates):** `jal`, `jalr`, `lui`, `auipc`

> **Note:** The `li` pseudo-instruction is natively supported via the assembler combining `lui` and `addi`.

---

## 🚀 Simulation & Verification

Prior to synthesis, the CPU's datapath and control logic were rigorously verified using Icarus Verilog and GTKWave. The verification suite utilizes targeted hex files mapped to ROM to independently validate specific pipeline behaviors and architectural edge cases.

### Verification Coverage Matrix

| Test Suite | Instructions Covered | Edge Cases Verified | Status |
|---|---|---|---|
| **ALU Arithmetic** | `add`, `sub`, `addi`, `lui`, `auipc` | Two's complement overflow, zero-input bypassing for U-Type decoding | ✅ Pass |
| **Logical & Shift** | `and`, `or`, `xor`, `sll`, `srl`, `sra` | Preservation of the sign-bit during arithmetic right shifts (`sra`) | ✅ Pass |
| **Control Flow** | `beq`, `bne`, `blt`, `bgeu`, `jal`, `jalr` | Unsigned vs. signed branch evaluation; Program Counter multiplexer routing | ✅ Pass |
| **Memory Sub-word** | `lw`, `sw`, `lb`, `lbu`, `sh`, `sb` | Sub-word RAM write masking; zero-extension vs. sign-extension on loads | ✅ Pass |

### Running the Testbenches

To reproduce the RTL simulations locally, execute the following commands in your terminal:

```bash
# Example: Running the memory sub-word verification suite
iverilog -g2012 -o core_sim.vvp src/*.v sim/tb_top.v
vvp core_sim.vvp
```

*(Open the resulting `.vcd` file in GTKWave to inspect register states and memory write masks.)*

---

## 🔌 SoC & Peripheral Integration

To interface with external hardware, the base CPU features a custom Universal Asynchronous Receiver-Transmitter (UART) peripheral.

- **MMIO Implementation:** The UART is mapped directly to the core's memory interface (Address `0x00002000`), allowing the CPU to transmit data using standard `sw` and `sb` instructions.
- **Hardware/Software Co-Design:** Successfully executes bare-metal assembly loops that poll the UART's busy status register (Address `0x00002004`) to continuously stream characters to a serial terminal without dropping frames.

---

## ⚡ Hardware Prototyping & Silicon Validation

The complete RTL design (RV32I Core + UART) has been successfully synthesized via Gowin EDA and deployed to physical hardware to validate logic gate utilization and physical timing constraints.

**Hardware Stack:** Sipeed Tang Primer 25K FPGA

### Prototype Demonstration

*(Below is the serial output of the RISC-V core executing a memory-mapped assembly loop and transmitting characters via the physical UART TX pin)*

```
[Insert your serial monitor output or image here]
```
