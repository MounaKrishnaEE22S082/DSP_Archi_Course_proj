import math
import cmath
import sys
from fixed_to_decimal import *

def dec_to_hex(num, sign):
    out = "{0:04x}".format(int(num * math.pow(2, 15)))
    return out

    #return "{0:04x}".format(int(num * math.pow(2, 15)))

if __name__ == "__main__":
    re_hex = sys.argv[1]
    img_hex = sys.argv[2]

    re = hex_convert(re_hex)
    img = hex_convert(img_hex)

    z = complex(re, img)
    z_sqrt = cmath.sqrt(z)
    act_re = z_sqrt.real
    act_imag = z_sqrt.imag;

    #1st vectoring mode
    R = math.sqrt(re*re + img*img)
    if (R > 1):
        R = R/4;
        l = 2
    else:
        l = 1
    si = math.atan(img/re)
    print("1st vectoring mode:")
    print("R = ", R, "hex: ", dec_to_hex(R, R < 0))
    print("si = ", si, "hex: ", dec_to_hex(si, si < 0))
    print()

    #2nd vectoring mode
    R_ = 2*R - 1
    TwoTheta = math.acos(R_)
    theta = TwoTheta / 2;
    print("2nd vectoring mode:")
    print("R_: ", R_, "hex: ", dec_to_hex(R_, R_ < 0))
    print("theta: ", theta, "hex: ", dec_to_hex(theta, theta < 0))
    print()

    #1st rotation mode
    sqrt_R = math.cos(theta)
    print("1st Rotation mode:")
    print("sqrt_R", sqrt_R, "hex: ", dec_to_hex(sqrt_R, sqrt_R < 0));
    print()

    #2nd rotation mode
    out_re = sqrt_R * math.cos(si/2) * l
    out_img = sqrt_R * math.sin(si/2) * l
    print("2st Rotation mode:")
    print("out_re: ", out_re, "hex: ", dec_to_hex(out_re, out_re < 0))
    print("out_img: ", out_img, "hex: ", dec_to_hex(out_img, out_img < 0))
    print("act_re: ", act_re, "hex: ", dec_to_hex(act_re, act_re < 0))
    print("act_img: ", act_imag, "hex: ", dec_to_hex(act_imag, act_imag < 0))
    print()

