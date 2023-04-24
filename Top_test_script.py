import math
import cmath
import sys
import os

sys.path.insert(0, "/home/mounakrishna/MS/DSP/DSP_Archi_Course_proj/verif_scripts")

from ref_cmplx_sqrt import generate_ref
from fixed_to_decimal import hex_convert



def dec_to_hex(num, sign):
    out = "{0:04x}".format(int(num * math.pow(2, 15)))
    return out

#ae = 0 #Absolute error
def check(exp_out, act_out, ae):


    return ae

if __name__ == "__main__":
    number_of_tests = int(sys.argv[1])

    generate_ref(number_of_tests)

    compile_cmd = 'iverilog -I./verilog_src/ -I./verilog_testbench/ -s tb_Top_Top -o verilog_testbench/tb_Top_Top verilog_testbench/tb_Top_Top.v verilog_src/Mux_Controller.v verilog_src/CV_CORDIC.v verilog_src/CR_CORDIC.v verilog_src/Top_Complex_SquareRoot.v'
    os.system(compile_cmd)
    run_cmd = './verilog_testbench/tb_Top_Top'
    os.system(run_cmd)

    exp_out_file = open("verilog_testbench/ref_outputs.txt", 'r')
    act_out_file = open("verilog_testbench/got_outputs.txt", 'r')
    err_file = open("err_file.txt", 'w')
    ae = 0

    for i in range(number_of_tests):
        exp_out = exp_out_file.readline()
        act_out = act_out_file.readline()

        exp_out_real = exp_out[:4]
        exp_out_imag = exp_out[4:]
        act_out_real = act_out[:4]
        act_out_imag = act_out[4:]

        exp_out_real_dec = hex_convert(exp_out_real)
        act_out_real_dec = hex_convert(act_out_real)
        exp_out_imag_dec = hex_convert(exp_out_imag)
        act_out_imag_dec = hex_convert(act_out_imag)

        err_real = abs(exp_out_real_dec - act_out_real_dec)
        err_imag = abs(exp_out_imag_dec- act_out_imag_dec)

        err = math.sqrt(err_real**2 + err_imag**2)
        ae += err

        err_file.write("exp: " + str(round(exp_out_real_dec, 4)) + "+" + str(round(exp_out_imag_dec, 4)) + " ")
        err_file.write("act: " + str(round(act_out_real_dec, 4)) + "+" + str(round(act_out_imag_dec, 4)) + " ")
        err_file.write("err: " + str(round(err, 4)) + "\n")

    mae = ae / number_of_tests

    print("Mean Absolute Error is: ", mae) 

    exp_out_file.close()
    act_out_file.close()
    err_file.close()
