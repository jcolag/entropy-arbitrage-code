#!/bin/bash
days=(mon tue wed thu fri)
maxidx=$((${#days[@]} - 1))
first="next ${days[0]}"
last="next ${days[$maxidx]}"
now=$(date +%N)
linkmins=$(rand -s $now -N 5 -M 5 -u | xargs -n 1 expr 1 + | paste -sd' ')
now=$(($now * 7 - 3))
quotemins=$(rand -s $now -N 5 -M 5 -u | xargs -n 1 expr 1 + | paste -sd' ')
mondate=$(date +%m/%d -d "$first")
longmon=$(date +"%B %dth, %Y" -d "$first")
fridate=$(date +%m/%d -d "$last")
pubdate=$(date +%F -d "$last")

IFS=' ' read -r -a linkmins <<< "$linkmins"
IFS=' ' read -r -a quotemins <<< "$quotemins"

filename="_posts/$pubdate-week.md"

rm -f $filename

cat > ${filename} <<HERE
---
layout: post
title: Tweets from ${mondate} to ${fridate}
date: ${pubdate} 16:11:12-0500
categories: media
tags: [twitter, week, socialmedia, linkdump]
summary: Tweets for the Week of ${longmon}
thumbnail: /blog/assets/CLM_14456_71r_detail.jpg
---

As [promised (or threatened)]({% post_url 2019-12-31-new-year %}), this is the weekly Twitter roundup.  Note that tweets of articles generally include header images from the articles, which are not included here unless they *happen* to be available under a free license.  Most are not.

![diagrams showing the division of the day and of the week](/blog/assets/CLM_14456_71r_detail.jpg "diagrams showing the division of the day and of the week")

HERE
#> "$filename"

for i in $(seq 0 $maxidx)
do
  day="next ${days[$i]}"
  dd=$(date +"%a %d %B %Y" -d "$day")
  cat >> ${filename} <<HERE
## 9:0${linkmins[$i]} -- ${dd}

[<i class="fab fa-twitter-square"></i>]() []() from 

 > 

## 12:0${quotemins[$i]} -- ${dd}

[<i class="fab fa-twitter"></i>]()

 > 

###### 

HERE
done

cat >> ${filename} <<HERE

* * *

**Credits**:  Header image is [Circular diagrams showing the division of the day and of the week](https://en.wikipedia.org/wiki/Week#/media/File:CLM_14456_71r_detail.jpg) from a manuscript drafted during the Carolingian Dynasty.
HERE

gedit ${filename}

