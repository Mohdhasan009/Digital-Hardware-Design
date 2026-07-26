# 11011 Sequence Detector

## Overview

This project implements a **11011 Mealy Sequence Detector** in Verilog HDL. The design detects the input bit pattern **11011** from a serial input stream and asserts the output for one clock cycle whenever the sequence is detected. Overlapping sequences are also supported through the finite state machine (FSM).

## Features

- Mealy Finite State Machine (FSM)
- Detects the serial sequence **11011**
- Supports overlapping sequence detection
- Clock divider for slow clock generation
- Input pulse generation for push-button debouncing
- Top-level integration module
- Tested using a Verilog testbench
- Successfully implemented on FPGA hardware

## Project Structure

```
rtl/
    fsm_11011.v
    clock_divider.v
    input_pulse.v
    top_sequence.v
    vio_wrapper.v

tb/
    sequence_detector_tb.v

images/

hardware_implementation/
```

## Module Description

- **fsm_11011.v** – Implements the Mealy FSM for sequence detection.
- **clock_divider.v** – Generates a slower clock for hardware testing.
- **input_pulse.v** – Produces a single pulse from the push-button input.
- **top_sequence.v** – Top-level module integrating all components.
- **vio_wrapper.v** – Wrapper used for FPGA debugging and verification.

## Hardware Implementation

The design was synthesized, implemented, and verified on FPGA hardware.

Hardware implementation images and demonstration videos are available in the `hardware_implementation` folder.

## Simulation

The functionality of the sequence detector was verified using a Verilog testbench. Simulation confirms correct detection of the **11011** sequence, including overlapping occurrences.

## Tools Used

- Verilog HDL
- Xilinx Vivado
- Git & GitHub

## Future Improvements

- Parameterizable sequence detector
- Moore FSM implementation
- Support for configurable sequence length
- Enhanced testbench with randomized input patterns

## Author

**Mohd Hasan**  
B.Tech Electronics (VLSI Design)  
Jamia Millia Islamia