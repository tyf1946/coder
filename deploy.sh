#!/usr/bin/env bash

#tim="$(date)"
#echo $tim
#echo ${tim}

git add -A
tim="$(date)"
message="$tim:$1"
git commit -m "\"message : $message \" "
git push origin master
echo $message

