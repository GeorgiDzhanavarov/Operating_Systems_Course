#!/bin/bash


grep "$(whoami)" /etc/passwd | cut -d':' -f 4
