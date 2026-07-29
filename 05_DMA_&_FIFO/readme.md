# DMA FIFO Data Transfer using AXI DMA (ZYBO)

This project demonstrates data transfer between the **Processing System (PS)** and an **AXI FIFO** using **AXI DMA** on the **ZYBO (Zynq-7000)** FPGA.

## Tools
- ZYBO (Zynq-7000)
- Xilinx Vivado
- Xilinx SDK
- C

## Features
- AXI DMA initialization
- Memory-to-Stream (MM2S) transfer
- Stream-to-Memory (S2MM) transfer
- Data cache management
- Verification of transmitted and received data

## Note
This project was developed as a Xilinx SDK application. Platform-specific files (BSP, hardware export, and generated headers) are not included in this repository and should be generated for the target hardware.

## Output
The application compares the transmitted and received data after DMA transfer and reports whether the transfer was successful.