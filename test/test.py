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

    dut._log.info("Testing full 8-bit Kogge-Stone adder behavior")

    error_count = 0  # Counter to track any failures

    for a in range(256):  # Iterate over the full 8-bit range for a
        # Set the range for b to ensure a + b does not exceed 255
        for b in range(256 - a):  # b ranges from 0 to 255 - a
            # Set the inputs to test each combination of a and b
            dut.a.value = a  
            dut.b.value = b
            # Wait for a few clock cycles to settle
            await ClockCycles(dut.clk, 1)

            # Calculate the expected sum
            expected_sum = (a + b) & 0xFF  # Sum limited to 8-bit
            
            # Log the values and verify the output
            dut._log.info(f"Testing a={a:08b}, b={b:08b}: Expected sum={expected_sum:08b}")
            sum_output = int(dut.sum.value)  # Read the full 8-bit sum output

            # Assert the sum value
            try:
                assert sum_output == expected_sum, f"Sum mismatch: got {sum_output:08b}, expected {expected_sum:08b}"
            except AssertionError as e:
                dut._log.error(str(e))
                error_count += 1

    dut._log.info(f"Testing completed with {error_count} errors.")
    assert error_count == 0, f"Test failed with {error_count} errors"
