#!/usr/bin/env bash

git add -A
message = $date + $1
git commit -m '$message '
git push origin master
echo message
