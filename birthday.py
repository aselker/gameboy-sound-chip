#!/usr/bin/env python3

import sys
import csv # Do we need this?
import re

csv_row_to_array_name = {"SQ1 Sweep Period": "sq1_swpPd",
   "SQ1 Negate": "sq1_negate",
   "SQ1 Shift": "sq1_shift",
   "SQ1 Duty": "sq1_duty",
   "SQ1 Length Load": "sq1_lenLoad",
   "SQ1 Starting Volume": "sq1_startVol",
   "SQ1 Envelope Add Mode": "sq1_envAdd",
   "SQ1 Period": "sq1_period",
   "SQ1 Starting Frequency": "sq1_freq",
   "SQ1 Trigger": "sq1_trigger",
   "SQ1 Length Enable": "sq1_lenEnable",
   "SQ2 Duty": "sq2_duty",
   "SQ2 Length Load": "sq2_lenLoad",
   "SQ2 Starting Volume": "sq2_startVol",
   "SQ2 Envelope Add Mode": "sq2_envAdd",
   "SQ2 Period": "sq2_period",
   "SQ2 Starting Frequency": "sq2_freq",
   "SQ2 Trigger": "sq2_trigger",
   "SQ2 Length Enable": "sq2_lenEnable"}

def verilog_statement(array_name, index, value):
   line = "%s[%s] <= %s;" % (array_name, index, value)
   return line


def noteToFreq(note):
  """
  Converts a music note (e.g. "Bb4") to gameboy "frequency"
  """
  # First, convert flats to sharps (or naturals)
  flatSharpLut = {"Ab" : "G#", "Bb" : "A#", "Cb" : "B ", "Db" : "C#", "Eb" : "D#", "Fb" : "E ", "Gb" : "F#"} 
  if note[0:2] in flatSharpLut:
    note = flatSharpLut[note[0:2]] + note[2:]

  notesLut = { "C 3": 44, "C#3": 156, "D 3": 262, "D#3": 363, "E 3": 457, "F 3": 547, "F#3": 631, "G 3": 710, "G#3": 786, "A 3": 854, "A#3": 923, "B 3": 986, "C 4": 1046, "C#4": 1102, "D 4": 1155, "D#4": 1205, "E 4": 1253, "F 4": 1297, "F#4": 1339, "G 4": 1379, "G#4": 1417, "A 4": 1452, "A#4": 1486, "B 4": 1517, "C 5": 1546, "C#5": 1575, "D 5": 1602, "D#5": 1627, "E 5": 1650, "F 5": 1673, "F#5": 1694, "G 5": 1714, "G#5": 1732, "A 5": 1750, "A#5": 1767, "B 5": 1783, "C 6": 1798, "C#6": 1812, "D 6": 1825, "D#6": 1837, "E 6": 1849, "F 6": 1860, "F#6": 1871, "G 6": 1881, "G#6": 1890, "A 6": 1899, "A#6": 1907, "B 6": 1915, "C 7": 1923, "C#7": 1930, "D 7": 1936, "D#7": 1943, "E 7": 1949, "F 7": 1954, "F#7": 1959, "G 7": 1964, "G#7": 1969, "A 7": 1974, "A#7": 1978, "B 7": 1982, "C 8": 1985, "C#8": 1988, "D 8": 1992, "D#8": 1995, "E 8": 1998, "F 8": 2001, "F#8": 2004, "G 8": 2006, "G#8": 2009, "A 8": 2011, "A#8": 2013, "B 8": 2015}

  return notesLut[note[:3]]


if __name__ == "__main__":

  # Read csv file
  csv_path = sys.argv[2]
  csv_read_file = open(csv_path, 'r')
  csv_text = csv_read_file.readlines()
  csv_read_file.close()

  assigns = []
  for line in csv_text:
    xs = line.rstrip().split(",")
    
    try:
      arrayName = csv_row_to_array_name[xs[0]]
    except KeyError: # Ignore unknown rows
      continue

    lastX = 0;
    for (i,x) in enumerate(xs[1:]): # Loop thru the rest of the line

      # First, convert to a Verilog-friendly number
      if x == "":
        if "trigger" in arrayName:
          x = 0
        else:
          x = lastX
      else:
        try:
          x = float(x)
        except ValueError:
          x = noteToFreq(x)
      lastX = x

      # Next, turn into a Verilog assign statement
      s = verilog_statement(arrayName, i, x)
      assigns += [s]

  # Read verilog file
  input_path = sys.argv[1]
  verilog_read_file = open(input_path, 'r')
  verilog_text = [x.rstrip() for x in verilog_read_file.readlines()]
  verilog_read_file.close()

  find = "// PYTHON GO HERE"
  replace = " ".join(assigns)

  # Which line has the marker?
  i = 0
  while find not in verilog_text[i]:
    i += 1

  verilog_text = verilog_text[:i] + [replace] + verilog_text[i+1:]

  print("\n".join(verilog_text))
  
  
