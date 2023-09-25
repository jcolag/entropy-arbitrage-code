#!/bin/bash
days=(mon tue wed thu fri)
captions=( \
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
cap=$(rand -M "${#captions[@]}")
maxidx=$((${#days[@]} - 1))
first="next ${days[0]}"
last="next ${days[$maxidx]}"
now=$(date +%N)
# The following SHOULD work, and works in testing,
# but somehow doesn't in this script.
# now="${now/#*(0)/}"
now=$(echo $now | sed 's/^0*//g')
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
tags: [linkdump, mastodon, socialmedia, week]
summary: Toots for the Week of ${longmon}
thumbnail: /blog/assets/CLM_14456_71r_detail.png
teaser: This week, we have 
---

As [discussed previously]({% post_url 2019-12-31-new-year %}), on Fridays, I present my weekly social media roundups.  Note that toots of articles generally include header images from the articles, which I don't include here unless their creators *happen* to have released them for use under a free license, and I notice.  Most have not, or I don't notice.  But I now add my commentary here, where I don't feel restricted by message length.

![diagrams showing the division of the day and of the week](/blog/assets/CLM_14456_71r_detail.png "${captions[cap]}")

Also, I don't generally attach pictures to posts with quotations.

HERE
#> "$filename"

for i in $(seq 0 $maxidx)
do
  day="next ${days[$i]}"
  dd=$(date +"%a %d %B %Y" -d "$day")
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

Hashtags:  #Quotes

HERE
done

cat >> "${filename}" <<HERE
## Bonus

Because it accidentally became a tradition early on in the life of the blog, I drop any additional articles that didn't fit into the one-article-per-day week, but too weird or important to not mention, here.

{% cw  %}
{% embed ||false| %}

<i class="fas fa-square"></i> []() from

 >



## Follow Me

If you appreciate this sort of content, then you should probably [follow me <i class="fab fa-mastodon"></i> on Mastodon](https://mastodon.social/@jcolag/) to get it as early as possible...and feel free to reply, at least to the good stuff.

* * *

**Credits**:  Header image is [Circular diagrams showing the division of the day and of the week](https://commons.wikimedia.org/wiki/File:CLM_14456_71r_detail.jpg) from a manuscript drafted during the Carolingian Dynasty.
HERE

gedit "${filename}"

