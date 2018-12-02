#!/usr/bin/env python3
import math
import sys

clockFreq = 4194304 # hz of main clock

# Read the header
header = sys.stdin.readline().split()
assert len(header) == 2
bitWidth = int(header[0])
sampleTime = int(header[1])
# sampleRate = clockFreq / sampleTime
sampleFreq = sampleTime / clockFreq

# Print the header
print("; Sample Rate " + str(clockFreq / sampleTime))
print("; Channels 2")

# Read and print the rest of the file
for line in sys.stdin:
  fields = list(int(f) for f in line.split())
  assert len(fields) == 3
  fields[0] = fields[0] / clockFreq
  # fields[0] = 0
  fields[1] = (fields[1]*2 / (2**bitWidth)) - 1 # Scale to between -1 and 1
  fields[2] = (fields[2]*2 / (2**bitWidth)) - 1 # Scale to between -1 and 1
  print(" ".join(str(f) for f in fields))
