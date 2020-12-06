import sys
import os

def str2bstr(s, len):
    s = trans_order(s, int(len/8))
    num = bin(int(s, 16))
    return str(num)[2:].zfill(len)

def trans_order(s, k):
    o = ''
    for i in range(1, k+1):
	    o = o + s[2*k-i*2]+s[2*k-i*2+1]
    return o

def input_proc(line):
    input_list = line.split()
    
    if line[0] == '0':
        text = str2bstr(input_list[1], 128)
        key = str2bstr(input_list[2], len(input_list[2])*4)
        ref = str2bstr(input_list[3], 128)
    elif line[0] == '1':
        ref = str2bstr(input_list[1], 128)
        key = str2bstr(input_list[2], len(input_list[2])*4)
        text = str2bstr(input_list[3], 128)
    return (ref+key+text+line[0]+'\n')

NR_VALUE_ARRAY = [ 10, 10, 12, 12, 14, 14]
NK_VALUE_ARRAY = [ 4, 4, 6, 6, 8, 8]
MODE_VALUE_ARRAY = [ 0, 1, 0, 1, 0, 1]
SAM_VALUE_ARRAY = []

# deal with input
with open("eval/AES_testcases_128.txt", 'r') as f_128:
    with open("eval/t_128.txt", 'w') as t_128:
        lines = f_128.readlines()
        SAM_VALUE_ARRAY.append(len(lines)-2)
        SAM_VALUE_ARRAY.append(len(lines)-2)
        for line in lines:
            if line[0] == '%':
                pass
            else:
                t_128.write(input_proc(line))
                 
with open("eval/AES_testcases_192.txt", 'r') as f_192:
    with open("eval/t_192.txt", 'w') as t_192:
        lines = f_192.readlines()
        SAM_VALUE_ARRAY.append(len(lines)-2)
        SAM_VALUE_ARRAY.append(len(lines)-2)
        for line in lines:
            if line[0] == '%':
                pass
            else:
                t_192.write(input_proc(line))

with open("eval/AES_testcases_256.txt", 'r') as f_256:
    with open("eval/t_256.txt", 'w') as t_256:
        lines = f_256.readlines()
        SAM_VALUE_ARRAY.append(len(lines)-2)
        SAM_VALUE_ARRAY.append(len(lines)-2)
        for line in lines:
            if line[0] == '%':
                pass
            else:
                t_256.write(input_proc(line))

# use ghdl to test
os.system("ghdl -a --ieee=synopsys --std=08 src/AddRoundKey.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/coefmult.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/gmult.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/KeyExpansion.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/MixColumns.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/ShiftRows.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/SubBytes.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/top.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/decryption.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 src/encryption.vhd")

for index in range(0, 6):
    os.system("cp sim/testbench.vhd.temptate sim/testbench.vhd")
    os.system("sed -i 's/NR_VALUE/" + str(NR_VALUE_ARRAY[index]) + "/g' sim/testbench.vhd")
    os.system("sed -i 's/NK_VALUE/" + str(NK_VALUE_ARRAY[index]) + "/g' sim/testbench.vhd")
    os.system("sed -i 's/MODE_VALUE/" + str(MODE_VALUE_ARRAY[index]) + "/g' sim/testbench.vhd")
    os.system("sed -i 's/SAM_VALUE/" + str(SAM_VALUE_ARRAY[index]) + "/g' sim/testbench.vhd")
    
    os.system("ghdl -a --ieee=synopsys --std=08 sim/testbench.vhd")
    os.system("ghdl -e --ieee=synopsys --std=08 testbench")
    os.system("ghdl -r --ieee=synopsys --std=08 testbench --ieee-asserts=disable | grep -v 'simulation finished @*'")

os.system("rm eval/t_128.txt")
os.system("rm eval/t_192.txt")
os.system("rm eval/t_256.txt")