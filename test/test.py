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
    max_val = 255  # Maximum sum value allowed
    a_vals = [i for i in range(256)]  # a can range from 0 to 255
    b_vals = [j for j in range(256)]  # b can also range from 0 to 255
    
    for i in (len(a_vals)):
        for j in (len(b_vals)):
            if a + b > max_val:
                continue  # Skip combinations that exceed 255
            
            # Set the input values
            dut.a.value = a_vals[i]
            dut.b.value = b_vals[j]
            
            # Wait for one clock cycle to see the output values
            await ClockCycles(dut.clk, 20)
          
            # Log the output and check the assertion
            dut._log.info(f"value of outputs are: {dut.sum.value}")
            assert int(dut.sum.value) == ((a_vals[i] + b_vals[j])%256)    

'''
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
    a_vals = [i for i in range(150)] #makes an array [0...15]
    b_vals = [i for i in range(16)] #makes an array [0...15]
    
    for i in range(len(a_vals)):
        for j in range(len(b_vals)):
            # Set the input values you want to test
            dut.a.value = a_vals[i]
            dut.b.value = b_vals[j]
            
            # Wait for one clock cycle to see the output values
            await ClockCycles(dut.clk, 20)
          
            # The following assersion is just an example of how to check the output values.
            # Change it to match the actual expected output of your module:
            dut._log.info(f"value of outputs are: {dut.sum.value}")
            assert int(dut.sum.value) == ((a_vals[i] + b_vals[j])%256)   
        
    
   

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
'''
    
'''
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
'''
