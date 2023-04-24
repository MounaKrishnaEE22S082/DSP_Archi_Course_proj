import math
import cmath
import sys
from fixed_to_decimal import *
import random

def generate_ref(number_of_tests):
    inp_file = open("verilog_testbench/inputs.txt", 'w')
    out_file = open("verilog_testbench/ref_outputs.txt", 'w')

    for i in range(number_of_tests):
        inp_real = random.uniform(0, 0.7)
        inp_imag = random.uniform(0, 0.7)

        inp_hex_real = "{0:04x}".format(int(inp_real * math.pow(2, 15)))
        inp_hex_imag = "{0:04x}".format(int(inp_imag * math.pow(2, 15)))

        inp_num = complex(inp_real, inp_imag)

        sqrt_dec = cmath.sqrt(inp_num)

        sqrt_hex_real = "{0:04x}".format(int(sqrt_dec.real * math.pow(2, 15)))
        sqrt_hex_imag = "{0:04x}".format(int(sqrt_dec.imag * math.pow(2, 15)))

        inp_file.write(str(inp_hex_real) + str(inp_hex_imag) + "\n")
        out_file.write(str(sqrt_hex_real) + str(sqrt_hex_imag) + "\n")

    inp_file.close()
    out_file.close()
