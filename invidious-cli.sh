#!/bin/bash
echo "Enter your search query"
read query
query_s=$(echo "$query" | sed 's:\s:+:g')
video=$(curl "https://invidious.kavin.rocks/api/v1/search/?q=$query_s" -s --retry-all-errors)
list=$(echo "$video" | grep -o -P '"title":"(.+?)","videoId"' | sed s/'"title":"'// | sed s/'","videoId"'// | sed 's:\\::g' | nl -b a)
echo "$list"
echo -e "\nEnter the number of the video you want to watch"
while :; do
read number
video_id=$(echo $video | grep -o -E '"videoId":"[^"]+"' | sed -n ''''$number'p''' | sed 's/"videoId"://' | sed 's/"//')
mpv https://invidious.kavin.rocks/watch?v=$video_id --fs 
clear
echo "$list"
echo -e "\nEnter another number, or quit by pressing Ctrl+C"
done
