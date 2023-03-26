#!/bin/bash

ls ~/songs | cut -d'-' -f1 | tr -d ' ' | uniq | xargs mkdir 
