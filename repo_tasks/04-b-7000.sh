#!/bin/bash


ps -eo user,size | tr -s ' ' | awk 'BEGIN{size = 0;all = 0} {if($1 == "root"){all+=1;size += $2}} END{if(all == 0){print "no root"} else {print size/all}}'
