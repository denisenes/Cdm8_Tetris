import keyboard
import tkinter
import argparse

#bank selector
#(only for our project)
#----------------------
def checkPC(curb, pc):
    if pc == 255:
        #go to another bank
        return curb ^ 1
    if pc == 253:
        # go to another bank
        return curb ^ 1

# ----------------------


#get image from file
parser = argparse.ArgumentParser()
parser.add_argument("--name")
parser.add_argument("--bank_count")
args = parser.parse_args()
name = args.name
kBank = args.bank_count
print(name)

#ROM
mem = [[""]*257]*int(kBank)

#RAM
data = [0]*256

for k in range(0, int(kBank)):
    file = open(name+str(k+1)+".img")
    i = 0;
    mem[k] = file.read().splitlines()

#for i in range(0, 257):
#    print(mem[1][i])

#execute program
C = N = V = Z = 0
r = [0]*4
stack = []
PC = 0
curBank = 0

def getRegs(reg):
    num = int(reg, 16)
    return (num // 4, num % 4)

def ldi(byte):
    global PC, mem, curBank, r
    reg = int(byte[1])
    #halt
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

def br():
    global PC, mem
    PC += 1
    addr = int(mem[curBank][PC], 16)
    PC = addr

#also tst
def move(byte):
    global r, V, C, N, Z
    (reg1, reg2) = getRegs(byte[1])
    r[reg2] = r[reg1]
    V = C = Z = N = 0
    if r[reg1] < 0:
        N = 1
    if r[reg1] == 0:
        Z = 1


##############################
#         main loop
##############################
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
    checkPC(curBank, PC)
    PC+=1


