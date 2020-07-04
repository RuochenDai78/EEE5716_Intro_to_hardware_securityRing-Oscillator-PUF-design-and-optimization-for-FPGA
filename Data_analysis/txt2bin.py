#!/usr/bin/python
#
# A simple script that convert dua file to bin file.

import sys
import binascii
binary = []

if len(sys.argv) != 2:
	print 'Usage: txt2bin.py <filename>'
	sys.exit(1)

fin = open (sys.argv[1], "r")

for line in fin.readlines():
	for i in line.split():
		a = hex(int(str(i), 2))[2:]
		if len(a) == 1:
			a = '0' + a
		b = binascii.a2b_hex(a)
		binary.append(b)

# Write results to file
#fout = open("rom_instruction.coe", 'wb')
out = sys.argv[1]
filename = out[:len(out)-4] + ".bin"
fout = open (filename, "w")

for i in range(len(binary)):
		fout.write("%s" %binary[i])
	
fout.close()
