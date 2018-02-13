#!/bin/bash

pdfjam --paper letter pions.pdf 1,11,16,19-20,23-24 -o small_single.pdf

pdfjam --paper letter pions.pdf 2-3,14-15,17-18,27-28 -o small_double.pdf
