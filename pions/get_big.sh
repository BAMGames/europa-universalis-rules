#!/bin/bash

pdfjam --papersize '{5.5in,8.5in}' pions.pdf 4,36 -o big_single.pdf

pdfjam --papersize '{5.5in,8.5in}' pions.pdf 5-12,14-15,27-30,37-40 -o big_double.pdf
