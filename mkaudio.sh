#!/bin/bash
./$1 | ./sox-converter.py > audio.dat && sox audio.dat audio.wav && rm audio.dat
