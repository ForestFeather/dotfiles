#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Please supply at least one host to install keys to, separated by spaces."
    exit -1
fi

for ip in $@; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
done
