#!/bin/bash


cat ~/dir5/file1 | sed -E 's/[A-Z]/\L&/g' > ~/dir5/file2
