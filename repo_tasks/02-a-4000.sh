#!/bin/bash

touch ~/permissions.txt

chmod 435 ~/permissions.txt 
chmod u=r,g=wx,o=rx ~/permissions.txt
