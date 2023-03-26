#!/bin/bash


ls ~/songs | sed -E 's/.* - (.*) \(.*/\1/g' | sed -E 's/[A-Z]/\L&/g' | tr -t ' ' '_' | sort
