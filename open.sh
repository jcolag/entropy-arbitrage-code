#!/bin/bash
day=0
pluma _sass/minima.scss
while [ $day -le 7 ]
do
  dd=$(faketime -f "+${day}d" date +%F)
  file=$(ls -1 _posts/${dd}-*.md 2> /dev/null)
  if [ ! -z $file ]
  then
    pluma $file
    sleep 1
  fi
  day=$((day + 1))
done
