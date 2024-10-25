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

    dut._log.info("Testing full 8-bit adder behavior")

    # Extended test to cover 8-bit range
    a_vals = [i for i in range(256)]  # All values from 0 to 255
    b_vals = [i for i in range(256)]  # All values from 0 to 255

    error_count = 0  # Counter to track any failures

    for a in a_vals:
        for b in b_vals:
            # Set the inputs to test each combination of a and b
            dut.ui_in.value = (b << 4) | a  # Concatenate a and b in 8-bit input format
            
            # Wait for 10 clock cycles
            await ClockCycles(dut.clk, 10)

            # Calculate the expected values
            expected_sum = (a + b) & 0xFF          # Sum limited to 8-bit
            expected_carry = 1 if (a + b) > 255 else 0  # Carry out if overflow occurs
            
            # Log the values and verify the output
            dut._log.info(f"Testing a={a}, b={b}: Expected sum={expected_sum}, carry={expected_carry}")
            sum_output = int(dut.uo_out.value & 0xFF)  # Mask to get the lower 8 bits
            carry_out = int(dut.uo_out.value >> 7)     # Get carry-out from MSB

            # Assert the sum and carry_out values
            try:
                assert sum_output == expected_sum, f"Sum mismatch: got {sum_output}, expected {expected_sum}"
                assert carry_out == expected_carry, f"Carry mismatch: got {carry_out}, expected {expected_carry}"
            except AssertionError as e:
                dut._log.error(str(e))
                error_count += 1

    dut._log.info(f"Testing completed with {error_count} errors.")
    assert error_count == 0, f"Test failed with {error_count} errors"
