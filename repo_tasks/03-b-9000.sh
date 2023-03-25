#!/bin/bash

find ~ -type f ! -name '.*' -mmin -15 -printf '%p %T@ \n' > ~/eternity
