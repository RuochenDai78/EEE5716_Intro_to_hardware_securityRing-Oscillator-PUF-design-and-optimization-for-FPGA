#!/usr/bin/python
#
# Takes a text file and converts the data to binary

import sys
import binascii
binary = []

if len(sys.argv) != 2:
	print 'Usage: bin2txt.py <filename>'
	sys.exit(1)

fin = open (sys.argv[1], "r")

while 1:
	char = fin.read(1)
	if not char: break
	a = binascii.b2a_hex(char)
	b = bin(int(a,16))[2:]
	even8bit = (len(b) % 8)
	if even8bit  != 0:
		b = '0'*(8-even8bit) + b
	binary.append(b)
	
out = sys.argv[1]
filename = out[:len(out)-4] + ".txt"
fout = open (filename, "w")

for i in range(len(binary)):
		fout.write("%s\n" %binary[i])
	
fin.close()
