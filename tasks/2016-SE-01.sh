#!/bin/bash

grep '[02468]' philip-j-fry.txt | grep -c -v '[a-w]'  
