#!/bin/bash

# Boilerplate
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
_ME="$(basename "${0}")"

if [[ "${TRACE-0}" == "1" ]]
then
  set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]
then
    echo "Usage: ${_ME} [filename]

This script will assemble a stub post for the following week's toots,
assuming that the post doesn't already exist.
"
    exit
fi

# For handing search-and-replace without invoking sed
shopt -s extglob

heritage_history () {
  mm="$1"
  dd="$2"

  case $mm in
    2)
      echo " #BlackHistory"
      ;;
    3)
      echo " #WomensHistory"
      ;;
    4)
      echo " #AsianAmericanHeritage"
      ;;
    5)
      echo " #AAPIHeritage"
      ;;
    6)
      echo " #LGBTPride"
      ;;
    7)
      echo " #DisabilityPride"
      ;;
    9)
      if [ "$dd" -gt 15 ]
      then
        echo " #HispanicHeritage"
      fi
      ;;
    10)
      if [ "$dd" -le 15 ]
      then
        echo " #HispanicHeritage"
      fi
      ;;
    10)
      echo " #FilipinoAmericanHistory"
      ;;
    11)
      echo " #NativeAmericanHeritage"
      ;;
    *)
      echo ""
  esac
  return 0
}

days=(mon tue wed thu fri)
division_captions=( \
  "Just what the world needed:  A calendar that flips the bird." \
  "And over here, we have...the Roman numeral for four, I guess." \
  "Some champion eye-rolling, there." \
  "Carmen Miranda presents the Days of the Week." \
  "Wait a second, are these all the same day of the week?" \
  "I hate Venn diagram memes, especially when they don't make any sense" \
  "I like to assume that the bust on the right, wearing a crown, blouse, and jacket, then shows up on the left, pointing with arms clad in sleeves made from woven wood slats..." \
  "I don't know, it seems to have turned into all cowlicks." \
  "What do you think, too much rouge for a monk?" \
)
abundance_captions=(\
  "I count four color schemes, right...?" \
  "Impressive to synchronize fouling up the pull-the-tablecloth trick with four Cupids..." \
  "The Sunday crowd should get themselves some of those eclipse glasses..." \
  "Note Monday's reenactment of pursuit of Diana as among the cowardly and superstitous lot..." \
  "Surf's up on Tuesday, everyone..." \
  "Dancing through Wednesdays" \
  "The Thursday crew wonders why they didn't ride the eagles to Mount Doom..." \
  "Friday on a half-shell" \
  "Saturday goes to the half-communists, I guess" \
)
cap=$(rand -M "${#abundance_captions[@]}")
maxidx=$((${#days[@]} - 1))
first="next ${days[0]}"
last="next ${days[$maxidx]}"
now=$(date +%N)
now="${now/#*(0)/}"
linkmins=$(seq 7 | sort -R | head -5 | paste -sd' ')
now=$((now * 7 - 3))
quotemins=$(seq 7 | sort -R | head -5 | paste -sd' ')
mondate=$(date +%m/%d -d "$first")
longmon=$(date +"%B %dXX, %Y" -d "$first" | sed -e 's/1\([0-9]\)XX/1\1th/' -e 's/1XX/1st/' -e 's/2XX/2nd/' -e 's/3XX/3rd/' -e 's/\([0,4-9]\)XX/\1th/')
fridate=$(date +%m/%d -d "$last")
pubdate=$(date +%F -d "$last")
TZ=$(date +%z -d "$last")

IFS=' ' read -r -a linkmins <<< "$linkmins"
IFS=' ' read -r -a quotemins <<< "$quotemins"

filename="_posts/$pubdate-week.md"
hh=17 # $((16 + offh))
HH=$(printf "%02d" "$hh")
mm=$(rand -M 60)
MM=$(printf "%02d" "$mm")
ss=$(rand -M 15)
SS=$(printf "%02d" "$ss")

if [ -f "${filename}" ]
then
  exit
fi

cat > "${filename}" <<HERE
---
layout: post
title: Toots 🦣 from ${mondate} to ${fridate}
date: ${pubdate} ${HH}:${MM}:${SS}${TZ}
categories:
tags: [link-dump, social-media, quotes, week]
summary: Toots for the Week of ${longmon}
thumbnail: /blog/assets/Elihu-Vedder-Abundance-Days-Week-1926.png
description: This week, we have .
spell: 
---

* Ignore for ToC
{:toc}

As [discussed previously]({% post_url 2019-12-31-new-year %}), on Fridays, I present my weekly social media roundups.  Note that toots of articles generally include header images from the articles, which I don't include here unless their creators *happen* to have released them for use under a free license, and I notice.  Most have not, or I don't notice.  But I now add my commentary here, where I don't feel restricted by message length.

![A painting with eleven inset scenes, the corners and central seven depicting the gods that give their names to the days of the week](/blog/assets/Elihu-Vedder-Abundance-Days-Week-1926.png "${abundance_captions[cap]}")

Also, I don't generally attach pictures to posts with quotations.

HERE
#> "$filename"

for i in $(seq 0 $maxidx)
do
  day="next ${days[$i]}"
  dd=$(date +"%a %d %B %Y" -d "$day")
  mm=$(date +%m | sed 's/^0*//g')
  date=$(date +%d | sed 's/^0*//g')
  qtag=$(heritage_history "$mm" "$dd")
  cat >> "${filename}" <<HERE
## 9:0${linkmins[$i]} -- ${dd}

{% cw  %}
{% embed ||false| %}

[<i class="fab fa-mastodon"></i>]() []() from

 >

Hashtags:  



## 12:0${quotemins[$i]} -- ${dd}

[<i class="fab fa-mastodon"></i> Quoted on Mastodon]()

 >

{% cite  %}

Hashtags:  #Quotes$qtag

HERE
done

cat >> "${filename}" <<HERE
## Bonus

Because it accidentally became a tradition early on in the life of the blog, I drop any additional articles that didn't fit into the one-article-per-day week, but too weird or important to not mention, here.

{% cw  %}
{% embed ||false| %}

<i class="fas fa-square"></i> []() from

 >



{% include follow.md %}

* * *

**Credits**:  Header image is [Abundance of The Days of the Week](https://artgallery.yale.edu/collections/objects/2806) by Elihu Vedder, long in the public domain due to an expired copyright.
HERE

gedit "${filename}"

