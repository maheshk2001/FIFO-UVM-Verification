# Asynchronous FIFO UVM Verification Framework

A complete UVM-based hardware verification environment for an asynchronous FIFO (First-In-First-Out) module with dual clock domains, implemented in SystemVerilog.

## Project Overview

This repository contains a professional-grade verification testbench for an asynchronous FIFO design using the UVM (Universal Verification Methodology) framework. The FIFO operates across two independent clock domains (read and write) and employs Gray code synchronization for safe clock domain crossing.

### Key Features

- **Asynchronous Design**: Independent read and write clock domains with CDC (Clock Domain Crossing) safe synchronization
- **Gray Code Synchronization**: Metastability-safe pointer synchronization between clock domains
- **UVM Testbench**: Complete UVM environment with agents, drivers, monitors, and scoreboard
- **Comprehensive Test Scenarios**:
  - Empty/Reset conditions
  - Random read/write operations
  - Overflow detection
  - Underflow detection
  - Back-to-back operations
- **16-bit Data Width, 16-location Depth**: Configurable parameters for flexible testing

## Directory Structure

```
├── FIFO-UVM-Verification/                    # Primary implementation 
│   ├── fifo_design.sv                    # DUT - Asynchronous FIFO implementation
│   ├── fifo_interface.sv                 # UVM interface with dual clock domains
│   ├── fifo_pkg.sv                       # Package containing all UVM components
│   ├── fifo_tb_top.sv                    # Top-level testbench module
│   ├── fifo_sequence_item.sv             # Transaction definition
│   ├── fifo_sequence.sv                  # Test sequences
│   ├── fifo_sequencer.sv                 # Sequencer for controlling stimulus
│   ├── fifo_driver.sv                    # Driver for sending transactions to DUT
│   ├── fifo_monitor.sv                   # Monitor for collecting responses
│   ├── fifo_agent.sv                     # Agent bundling driver, sequencer, monitor
│   ├── fifo_scoreboard.sv                # Functional checker and assertions
│   ├── fifo_environment.sv               # UVM environment
│   ├── fifo_test.sv                      # Test class and scenarios
│   └── subscriber.sv                     # Coverage subscriber

```

## Design Details

### FIFO Parameters
- **DATA_WIDTH**: 16 bits (configurable)
- **DEPTH**: 16 locations (configurable)
- **ADDR_WIDTH**: 4 bits (log2 of DEPTH)

### Interface Signals

#### Write Clock Domain
- `w_clk`: Write clock
- `rstn`: Active-low reset
- `w_en`: Write enable
- `w_data[15:0]`: Write data
- `full_flag`: FIFO full indicator

#### Read Clock Domain
- `r_clk`: Read clock
- `r_en`: Read enable
- `r_data[15:0]`: Read data
- `empty_flag`: FIFO empty indicator

### Key Components

#### 1. **FIFO Design** (fifo_design.sv)
- Dual-clock asynchronous FIFO implementation
- Separate write and read pointer logic
- Gray code conversion for safe CDC
- Synchronized pointers between clock domains
- Metastability prevention using double-flop synchronizers

#### 2. **UVM Testbench Components**

- **Sequencer** (fifo_sequencer.sv): Controls stimulus generation
- **Driver** (fifo_driver.sv): Converts transactions into interface signals
- **Monitor** (fifo_monitor.sv): Observes DUT behavior and collects coverage
- **Agent** (fifo_agent.sv): Bundles sequencer, driver, and monitor
- **Scoreboard** (fifo_scoreboard.sv): 
  - Implements a shadow FIFO model
  - Checks data integrity
  - Validates FIFO status signals
  - Reports pass/fail results

#### 3. **Test Scenarios** (fifo_test.sv)

Multiple test sequences verify different FIFO behaviors:

- **fifo_empty_read_sequence**: Tests reset and empty FIFO reads
- **fifo_RAW_sequence**: Validates read-after-write operations
- **fifo_overflow_sequence**: Tests full FIFO behavior
- **fifo_underflow_sequence**: Tests empty FIFO behavior
- **fifo_random_sequence**: Stress testing with random operations
- **fifo_ZeroOneR_sequence**: Boundary condition testing

## Getting Started

### Prerequisites
- Xilinx Vivado or any SystemVerilog simulator (ModelSim, VCS, etc.)
- UVM library 1.2 or later
- SystemVerilog support for the simulator

### Running the Testbench

#### Using Xilinx Vivado
1. Create a new project in Vivado
2. Add all `.sv` files from the `FIFO-UVM-Verification` directory
3. Set `fifo_tb_top` as the top module
4. Run behavioral simulation


## UVM Architecture

```
fifo_test
    |
    └── fifo_environment
        |
        ├── fifo_agent
        |   ├── fifo_sequencer
        |   ├── fifo_driver
        |   └── fifo_monitor
        |
        └── fifo_scoreboard
```

## Test Execution Flow

1. **Build Phase**: Environment and all UVM components are instantiated
2. **Reset Phase**: FIFO is reset to empty state
3. **Run Phase**: Multiple test sequences execute:
   - Reset verification
   - Read-after-write sequences
   - Overflow conditions
   - Random operations
   - Corner cases
4. **Report Phase**: Scoreboard reports test results and coverage statistics

## Verification Results

The testbench validates:
- ✅ Data integrity across transactions
- ✅ Proper full/empty flag operation
- ✅ CDC safety and synchronization
- ✅ FIFO behavior under stress conditions
- ✅ Reset functionality
- ✅ Boundary conditions (empty/full/nearly full)

### Adding Custom Sequences
Create new sequence classes in `fifo_sequence.sv` and add them to test execution in `fifo_test.sv`

### Coverage Enhancement
Expand the monitor in `fifo_monitor.sv` to collect additional functional and code coverage

## License

MIT License

Copyright (c) 2026 Mahesh Kaushik Srihasam

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Authors

**Mahesh Kaushik Srihasam**


**Last Updated**: January 2026  
**Status**: Complete and Verified  
**Simulation Tools Tested**: Xilinx Vivado, VCS(EDA_Playground).
