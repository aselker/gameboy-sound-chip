#!/usr/bin/env python

import sys
import csv

csv_row_to_array_name = {"SQ1 Sweep Period": "sq1_swpPd",
   "SQ1 Negate": "sq1_negate",
   "SQ1 Shift": "sq1_shift",
   "SQ1 Duty": "sq1_duty",
   "SQ1 Length Load": "sq1_lenLoad",
   "SQ1 Starting Volume": "sq1_startVol"}

def verilog_statement(array_name, index, value):
   line = "%s[%s] <= %s;\n" % (array_name, index, value)
   return line

if __name__ == "__main__":
   
   # Read file
   input_path = sys.argv[1]
   verilog_read_file = open(input_path, 'r')
   verilog_text = verilog_read_file.readlines()
   verilog_read_file.close()
   replace_string = "// PYTHON GO HERE"

   # Generate verilog statements








    
