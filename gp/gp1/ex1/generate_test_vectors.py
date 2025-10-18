import os
from pathlib import Path
from numpy.random import randint

N_INIT   = 5
N_RAND   = 10
NB_RST_N = 1
NB_SEL   = 2
NB_IDATA = 3
NB_ODATA = 6

i_rst_n = 1
i_sel, i_data1, i_data2   = 0, 0, 0
o_mux, o_data, o_overflow = 0, 0, 0

vectors = \
{
    "i_rst_n":    [i_rst_n]    * N_INIT, "i_sel"  : [i_sel]   * N_INIT,
    "i_data1":    [i_data1]    * N_INIT, "i_data2": [i_data2] * N_INIT,
    "o_mux"  :    [o_mux]      * N_INIT, "o_data" : [o_data]  * N_INIT,
    "o_overflow": [o_overflow] * N_INIT,
 }

for i_sel in range(2**NB_SEL):
    for i_data1 in range(2**NB_IDATA):
        for i_data2 in range(2**NB_IDATA):
            
            i_rst_n = 0
            
            if i_sel == 0:
                o_mux = i_data2
            elif i_sel == 1:
                o_mux = i_data2 + i_data2
                o_mux -= 2**(NB_IDATA + 1) * (o_mux // 2**(NB_IDATA + 1))
            elif i_sel == 2:
                o_mux = i_data1
            else:
                o_mux = 0

            for iter in range(((2**NB_ODATA - 1)//o_mux + 1 + randint(1, N_RAND))
                                if o_mux > 0 else randint(1, N_RAND)):
                
                vectors["i_rst_n"].append(i_rst_n)
                vectors["i_sel"].append(i_sel)
                vectors["i_data1"].append(i_data1)
                vectors["i_data2"].append(i_data2)

                if i_rst_n == 0:
                    i_rst_n = 1
                    o_data = 0
                    o_overflow = 0
                else:
                    o_data += o_mux
                    o_overflow = (o_data // 2**(NB_ODATA))
                    o_data -= 2**(NB_ODATA) * (o_data // 2**(NB_ODATA))
                
                vectors["o_mux"].append(o_mux)
                vectors["o_data"].append(o_data)
                vectors["o_overflow"].append(o_overflow)

p = Path('.') / 'vectors'
if not os.path.exists(p):
    os.mkdir(p)

for vname in vectors:
    with open(p / (vname + ".out"), "w") as f:
        for value in vectors[vname]:
            f.write(f"{value}\n")
