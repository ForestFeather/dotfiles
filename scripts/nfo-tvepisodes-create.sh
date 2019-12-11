#!/bin/bash

first=1
IFS=$'\n'

# Create NFO files, first we just work on splitting

# Get files
for i in `find . -type f -name "*.mp4"`; do
    elements=($( echo "$i" | awk 'BEGIN {FS=" X.X "} {for(l=1;l<=NF;l++)print $l}' ))
    
    if [ $first == 1 ]; then
        first=0
        #nfo-tvshow.sh "${elements[0]:2}"
        # Change to put content creator in name title
        dirname="$(pwd)"
        result="${dirname%"${dirname##*[!/]}"}"
        result="${result##*/}"
        nfo-tvshow.sh "$result"
    fi
 
    # 2019-12-10: removing this old way, as now have the python script
    #nameminusfiletype="${i::-4}"
    #eptitlefull="${elements[4]}"
    #eptitle="${eptitlefull::-4}"
    #episode="${elements[3]}"
    #fullaired="${elements[1]}"
    #airedyear="$( echo "$fullaired" | cut -c1-4 )"
    #airedmonth="$( echo "$fullaired" | cut -c5-6 )"
    #airedday="$( echo "$fullaired" | cut -c7-8 )"
#
#    echo "<episodedetails>
#    <title>${eptitle}</title>
#    <season>1</season>
#    <episode>${episode}</episode>
#    <aired>${airedyear}-${airedmonth}-${airedday}</aired>
#</episodedetails>" > "${i:2:-4}.nfo"

    python ~/scripts/detailed-tvepisodes-nfo-create.py

done;


