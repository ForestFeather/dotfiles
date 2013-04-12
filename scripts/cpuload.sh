# script found on http://unix.stackexchange.com/questions/27076/how-can-i-receive-top-like-cpu-statistics-from-the-shell
#!/bin/bash
read cpu a b c previdle rest < /proc/stat
prevtotal=$((a+b+c+previdle))
sleep 0.5
read cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))
CPU=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
echo "${CPU}%"
