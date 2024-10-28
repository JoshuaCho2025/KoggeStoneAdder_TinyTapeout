# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("Test project behavior")
    
    # Generate test values for a and b
    a_vals = range(256)  # Values from 0 to 255
    b_vals = range(256)  # Values from 0 to 255
    
    for a in a_vals:
        for b in b_vals:
            if a + b <= 255:  # Only test pairs where the sum is <= 255
                # Set the input values you want to test
                dut.a.value = a
                dut.b.value = b
                
                # Wait for one clock cycle to see the output values
                await ClockCycles(dut.clk, 1)

                # Log the output and check if the sum is correct
                dut._log.info(f"a: {a}, b: {b}, sum: {dut.sum.value}")
                assert int(dut.sum.value) == (a + b) % 256
