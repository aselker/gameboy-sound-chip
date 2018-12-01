#!/usr/bin/env python3
import math

print("; Sample Rate 16000")
print("; Channels 1")

for i in range(0,100000):
  # print(str(i / 16000) + " " + str(math.sin((i / 16000) * 440 * (2 * math.pi))))
  print("0 " + str(math.sin((i / 16000) * 440 * (2 * math.pi))))
