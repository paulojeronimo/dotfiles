#!/bin/bash

mkdir -p mp3
for f in *.m4a
do
    dest=mp3/${f%.m4a}.mp3
    [ -f "$dest" ] && continue
    ffmpeg "$dest" -i "$f" -c:a libmp3lame -q:a 1
done
