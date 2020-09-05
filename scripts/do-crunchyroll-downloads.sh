#!/bin/bash

links=$( cat crunchyroll*.txt )
for link in $links
do
    youtube-dl --cookies ~/cr_cookies.txt --tls-min-v1.3 --min-sleep-interval 60 --max-sleep-interval 1800 --download-archive archive.list --all-subs --write-description -f 'bestvideo[ext=mp4][height<=?1080][filesize<512M][height>=?360]>+bestaudio[ext=m4a]/best[ext=mp4][height<=?1080][height>=?360][filesize<512M]/best[ext=mp4]/best' -o '%(series)s/S01E%(playlist_index)s X.X %(playlist_index)s X.X %(title)s.%(ext)s' --user-agent "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0" "$link"
done
