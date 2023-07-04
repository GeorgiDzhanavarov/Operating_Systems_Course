#!/bin/bash


if [[ $# -ne 2 ]]; then
        echo "Not enough arguments"
        exit 2
fi

if [[ ! -f $1 ]] ; then
        echo "First argument should be file"
        exit 3
fi

if [[ ! -d $2 ]]; then
        echo "Second argument should be directory"
        exit 4
fi

if [[ -n $(find $2 -maxdepth 0 -empty) ]]; then
        echo "Directory empty nothing to search for"
        exit 5
fi

if [[ -z $(find $2 -type f -name "*.log") ]]; then
        echo "There are not .log files to read from"
        exit 6
fi


echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key"

while read file; do
        hostname=$(basename $file .log)
        license="$(fgrep  "This platform has" $file | sed -E 's/This platform has an? (.*) license\./\1/')"
        #echo $license
        cat $file | awk -F':' -v name=$hostname -v license="$license" 'BEGIN {OFS=","}
                $1 ~ /Maximum/ {phy=$2}
                $1 ~ /VLANs/ {vlans=$2}
                $1 ~ /Inside/ {hosts=$2}
                $1 ~ /Failover/ {failover=$2}
                $1 ~ /VPN-3DES-AES/ {vpn=$2}
                $1 ~ /\*Total/ {peers=$2}
                $1 ~ /VLAN Trunk/ {vlan_trunk=$2}
                $1 ~ /Serial/ {sn=$2}
                $1 ~ /Running/ {key=$2}
                END {
                        print name,phy,vlans,hosts,failover,vpn,peers,vlan_trunk,license,sn,key
                }
        ' | sed -E 's/\s//g'

done < <(find $2 -type f -name "*.log")
