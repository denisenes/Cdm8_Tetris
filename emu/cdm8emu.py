import keyboard
import tkinter
import argparse


# bank selector
# (only for our project)
# ----------------------
def checkPC(curb, pc):
    if pc == 255:
        # go to another bank
        return curb ^ 1
    if pc == 253:
        # go to another bank
        return curb ^ 1


# ----------------------


# get image from file
parser = argparse.ArgumentParser()
parser.add_argument("--name")
parser.add_argument("--bank_count")
args = parser.parse_args()
name = args.name
kBank = args.bank_count
print(name)

# ROM
mem = [[""] * 257] * int(kBank)

# RAM
data = [0] * 256

for k in range(0, int(kBank)):
    file = open(name + str(k + 1) + ".img")
    i = 0;
    mem[k] = file.read().splitlines()

# for i in range(0, 257):
#    print(mem[1][i])

# execute program
C = N = V = Z = 0
r = [0] * 4
stack = []
PC = 0
curBank = 0


def checkFlags(value):
    global C, V, Z, N
    C = Z = N = V = 0
    if value == 0:
        Z = 1
    elif value >= 128:
        N = 1


def getRegs(reg):
    num = int(reg, 16)
    return (num // 4, num % 4)


def getSingleReg(reg):
    num = int(reg, 16)
    return num % 5


# memory
def ldi(byte):
    global PC, mem, curBank, r
    reg = int(byte[1])
    # halt
    if reg == 4:
        print(r[0], r[1], r[2], r[3])
        exit()
    print("LDI REG -- " + str(reg))
    PC += 1
    r[reg] = int(mem[curBank][PC], 16)
    print("LDI ADDRESS -- " + str(r[reg]))


def ld(byte):
    global data, r
    (reg1, reg2) = getRegs(byte[1])
    r[reg2] = data[reg1]
    print(str(reg1), str(reg2))


def st(byte):
    global data, r
    (reg1, reg2) = getRegs(byte[1])
    data[r[reg1]] = r[reg2]


def br():
    global PC, mem
    PC += 1
    addr = int(mem[curBank][PC], 16)
    PC = addr


# also tst
def move(byte):
    global r, V, C, N, Z
    (reg1, reg2) = getRegs(byte[1])
    r[reg2] = r[reg1]
    V = C = Z = N = 0
    checkFlags(r[reg2])


# stack
def push(reg):
    global r
    stack.append(r[reg])


def pop(reg):
    global r
    r[reg % 4] = stack.pop()


def clr(byte):
    global r, V, C, N, Z
    C = Z = 1
    V = N = 0
    reg = getSingleReg(byte)
    r[reg] = 0


def unarOperator(sym):
    global r
    reg = int(sym, 16)
    if reg in [0, 1, 2, 3]:
        # not
        r[reg] = ~r[reg]
    elif reg in [4, 5, 6, 7]:
        # neg
        r[reg % 4] = (-r[reg % 4] + 256) % 256
    elif reg in [8, 9, 10, 11]:
        # dec
        r[reg % 4] = r[reg % 4] - 1
    elif reg in [12, 13, 14, 15]:
        # inc
        r[reg % 4] = r[reg % 4] + 1


# logic operations
def andd(byte):
    (reg1, reg2) = getRegs(byte)
    r[reg2] = r[reg1] & r[reg2]
    checkFlags(r[reg2])


def orr(byte):
    (reg1, reg2) = getRegs(byte)
    r[reg2] = r[reg1] | r[reg2]
    checkFlags(r[reg2])


def xorr(byte):
    (reg1, reg2) = getRegs(byte)
    r[reg2] = r[reg1] ^ r[reg2]
    checkFlags(r[reg2])


def add(byte):
    global C, V, N, Z
    (reg1, reg2) = getRegs(byte)
    temp1 = r[reg1]
    temp2 = r[reg2]
    r[reg2] = r[reg1] + r[reg2]
    checkFlags(r[reg2])
    # check C and V
    if r[reg2] >= 256:
        C = 1
    if temp1 < 128 & temp2 < 128 & r[reg2] % 256 >= 128:
        V = 1
    if temp1 >= 128 & temp2 >= 128 & r[reg2] % 256 < 128:
        V = 1
    r[reg2] %= 256
    print(temp1, temp2)
    print(r[reg2])
    print("Flags: ", C, V, Z, N)


def sub(byte):
    (reg1, reg2) = getRegs(byte)
    unarOperator(str(4 + reg2))
    add(byte)


#############################
#         main loop         #
#############################
while PC < 257:
    cell = mem[curBank][PC]
    if cell[0] == 'D':
        ldi(cell)
    elif cell[0] == 'B':
        ld(cell)
    elif cell[0] == 'E' and cell[1] == 'E':
        br()
    elif cell[0] == "0":
        move(cell)
    elif cell[0] == "A":
        st(cell)
    elif cell[0] == "C":
        stack_reg = int(cell[1])
        if int(stack_reg < 4):
            push(stack_reg)
        else:
            pop(stack_reg)
    elif cell[0] == "8":
        unarOperator(cell[1])
    elif cell[0] == "4":
        andd(cell[1])
    elif cell[0] == "5":
        orr(cell[1])
    elif cell[0] == "6":
        xorr(cell[1])
    elif cell[0] == "1":
        add(cell[1])
    elif cell[0] == "3":
        sub(cell[1])
    checkPC(curBank, PC)
    PC += 1
