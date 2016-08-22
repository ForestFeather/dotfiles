#/bin/bash

title=$@

echo '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<tvshow>
    <title>$title</title>
</tvshow>' >> tvshow.nfo
