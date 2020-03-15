#!/usr/bin/env bash

git add -A
tim = $(date)
message = "$(tim) : $(0)"
git commit -m "\"message : $(message) \" "
git push origin master
echo message
