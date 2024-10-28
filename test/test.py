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
    a_vals = [i for i in range(256)] #makes an array [0...255]
    b_vals = [i for i in range(256)] #makes an array [0...255]
    
    for i in range(len(a_vals)):
        for j in range(len(b_vals)):
            # Set the input values you want to test
            if (a_vals[i] + b_vals[j]) < 256:
                dut.a.value = a_vals[i]
                dut.b.value = b_vals[j]
                
                # Wait for one clock cycle to see the output values
                await ClockCycles(dut.clk, 20)
                  
                # The following assersion is just an example of how to check the output values.
                # Change it to match the actual expected output of your module:
                dut._log.info(f"value of outputs are: {dut.sum.value}")
                assert int(dut.sum.value) == ((a_vals[i] + b_vals[j])%256) if   
            else: 
                # Wait for one clock cycle to see the output values
                dut.a.value = a_vals[i]
                dut.b.value = b_vals[j]
                await ClockCycles(dut.clk, 20)
                continue
