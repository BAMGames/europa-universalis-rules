#!/bin/bash

pdfjam --paper letter pions.pdf 1,11,16,19-21,26 -o small_single.pdf

pdfjam --paper letter pions.pdf 2-3,14-15,17-18,24-25 -o small_double.pdf
