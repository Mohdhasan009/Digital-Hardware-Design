# 8-bit Counter

## Overview

This project implements an **8-bit synchronous binary counter** in Verilog HDL. The design was developed and verified using **Xilinx Vivado**, including RTL simulation and hardware implementation on an FPGA.

---

## Features

- 8-bit synchronous binary counter
- Positive edge-triggered design
- Clock divider for slow clock generation
- Top-level integration module
- Functional verification using a Verilog testbench
- Hardware implementation and validation on FPGA

---

## Project Structure

```text
01_8bit_counter/
│
├── rtl/
│   ├── counter.v
│   ├── clock_divider.v
│   ├── top_counter.v
│   └── vio_wrapper.v
│
├── tb/
│   └── counter_tb.v
│
├── demo/
│   └── hardware_implementation.mp4
│
├── images/
│   ├── waveform.png
│   └── rtl_schematic.png
│
└── README.md
```

---

## Hardware Demonstration

A hardware demonstration of the implemented design running on the FPGA development board is available below:

📹 **Hardware Implementation:**  
[▶ View Hardware Demonstration](hardware_implementation.mp4)

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- Git
- GitHub

---

## Author

**Mohd Hasan**

B.Tech Electronics Engineering (VLSI Design & Technology)  
Jamia Millia Islamia
