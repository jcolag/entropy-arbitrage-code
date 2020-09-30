#!/bin/bash
days=(mon tue wed thu fri)
maxidx=$((${#days[@]} - 1))
first="next ${days[0]}"
last="next ${days[$maxidx]}"
now=$(date +%N)
linkmins=$(rand -s $now -N 5 -M 5 -u | xargs -n 1 expr 1 + | paste -sd' ')
now=$(echo $now | sed 's/^0*//g')
now=$(($now * 7 - 3))
quotemins=$(rand -s $now -N 5 -M 5 -u | xargs -n 1 expr 1 + | paste -sd' ')
mondate=$(date +%m/%d -d "$first")
longmon=$(date +"%B %dth, %Y" -d "$first")
fridate=$(date +%m/%d -d "$last")
pubdate=$(date +%F -d "$last")
TZ=$(date +%z -d "$last")

IFS=' ' read -r -a linkmins <<< "$linkmins"
IFS=' ' read -r -a quotemins <<< "$quotemins"

filename="_posts/$pubdate-week.md"
offh=$(rand -M 4)
hh=$((14 + $offh))
HH=$(printf "%02d" $hh)
mm=$(rand -M 60)
MM=$(printf "%02d" $mm)
ss=$(rand -M 60)
SS=$(printf "%02d" $ss)

if [ -f ${filename} ]
then
  exit
fi

cat > ${filename} <<HERE
---
layout: post
title: Tweets from ${mondate} to ${fridate}
date: ${pubdate} ${HH}:${MM}:${SS}${TZ}
categories: media
tags: [twitter, week, socialmedia, linkdump]
summary: Tweets for the Week of ${longmon}
thumbnail: /blog/assets/CLM_14456_71r_detail.png
---

As [discussed previously]({% post_url 2019-12-31-new-year %}), this is my weekly Twitter roundup.  Note that tweets of articles generally include header images from the articles, which are not included here unless they *happen* to be available under a free license.  Most are not.  But I now add most of my commentary here, where I'm not restricted by the message length.

![diagrams showing the division of the day and of the week](/blog/assets/CLM_14456_71r_detail.png "diagrams showing the division of the day and of the week")

I also don't generally attach pictures to posts with quotations.

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
## Bonus

Because it accidentally became a tradition early on in the life of the blog, here's a sixth article that didn't fit into the week, but too weird to not mention.

<i class="fas fa-square"></i> []() from

 >

* * *

**Credits**:  Header image is [Circular diagrams showing the division of the day and of the week](https://en.wikipedia.org/wiki/Week#/media/File:CLM_14456_71r_detail.jpg) from a manuscript drafted during the Carolingian Dynasty.
HERE

pluma ${filename}

