#!/bin/bash


ls ~/songs | sed -E 's/.* - (.*) \(.*/\1/g'
