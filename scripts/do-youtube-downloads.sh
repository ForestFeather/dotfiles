#!/bin/bash

links=$( cat *.txt )
for link in $links
do
    youtube-dl -v -f 'bestvideo[ext=mp4][height<=?1080][filesize<512M][height>=?360]+bestaudio[ext=m4a]/best[ext=mp4][height<=?1080][filesize<512M][height>=?360]/best' --download-archive archive.list -o '%(playlist)s - %(uploader)s/%(playlist)s X.X %(release_date)s X.X S01E%(playlist_index)s X.X %(playlist_index)s X.X %(title)s.%(ext)s' "$link"
done
