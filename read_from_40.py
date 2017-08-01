#!/usr/bin/env python

from smbus2 import *
import time
import struct

# INA3221 address
addr = 0x40

# milli-ohms
rshunt = [20, 10, 10]

vshuntReg = [0x01, 0x03, 0x05]
vbusReg = [0x02, 0x04, 0x06]

def convShuntVol(addr, reg):
    v = struct.unpack('>h', struct.pack('<H', bus.read_word_data(addr, reg)))[0]
    return int((v >> 3) * 40)

def convBusVol(addr, reg):
    v = struct.unpack('>h', struct.pack('<H', bus.read_word_data(addr, reg)))[0]
    return int((v >> 3) * 8)

def calcCurr(v,r):
    return int(v/float(r))

def calcPow(v,i):
    return int(v*i/1000)

with SMBusWrapper(1) as bus:

    with open("pow.log", 'w') as f:

        while(True):

            vshunt=[]
            vbus=[]

            curr = []
            power = []

            for reg in vshuntReg:
                vshunt.append(convShuntVol(addr, reg))

            for reg in vbusReg:
                vbus.append(convBusVol(addr, reg))

            for i in range(3):
                curr.append(calcCurr(vshunt[i], rshunt[i]))
                
            for i in range(3):
                power.append(calcPow(vbus[i], curr[i]))

            # print("Shunt voltages (mV): {}".format(vshunt))
            # print("Bus voltages (mV): {}".format(vbus))

            # print("Current (mA): {}".format(curr))
            # print("Power (mW): {}".format(power))
        
            time.sleep(1)

            f.write("{},{},{}\n".format(power[0],power[1],power[2]))
            print("{},{},{}\n".format(power[0],power[1],power[2]))
            f.flush()
