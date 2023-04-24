import math
import sys

def hex_convert(hex_num):
    bin_num = bin(int(hex_num, 16))[2:]
    zeros_padding = 16 - len(bin_num) 
    for i in range(zeros_padding):
        bin_num = "0" + bin_num

    dec_num = 0
    for i in range(16):
        dec_num += int(bin_num[i]) * math.pow(2, -i)

    #print("Dec_num:", dec_num)
    return dec_num

if __name__ == "__main__":
    hex_num = sys.argv[1]
    hex_convert(hex_num)

