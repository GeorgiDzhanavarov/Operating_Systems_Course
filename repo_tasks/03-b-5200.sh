#!/bin/bash

cat /etc/passwd | sed 's/а//g' | wc -m
