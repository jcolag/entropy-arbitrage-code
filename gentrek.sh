#!/bin/sh
START=$1
END=$2
when=$3

for num in $(seq "$START" "$END")
do
  xscript=$(mktemp --suffix=.txt)
  HH=17
  mm=$(rand -M 60)
  MM=$(printf "%02d" "$mm")
  ss=$(rand -M 15)
  SS=$(printf "%02d" "$ss")
  TZ=$(date -d "${when}" +"%z")

  curl --silent "http://www.chakoteya.net/NextGen/${num}.htm" \
    | html2text -style pretty -width 100000 -utf8 \
    | sed 's/^\s*//g;s/\s*$//g' \
    | head --lines=-3 \
    > "${xscript}"
  title=$(head --lines=4 "${xscript}" | tail --lines=1)
  # script=$(tail --lines=+8 "${xscript}")
  slug=$(echo "${title}" | tr '[:upper:]' '[:lower:]' | sed "s/'ll/ will/g" | sed 's/&/and/g' | sed 's/\(\ba\b\)\|\(\balways\b\)\|\(\bamong\b\)\|\(\band\b\)\|\(\bat\b\)\|\(\bbefore\b\)\|\(\bhas\b\)\|\(\bhave\b\)\|\(\blast\b\)\|\(\bname\b\)\|\(\bno\b\)\|\(\bnow\b\)\|\(\bof\b\)\|\(\bone\b\)\|\(\bthe\b\)\|\(\btoo\b\)\|\(\bus\b\)\|\(\bwe\b\)\|\(\bwhen\b\)\|\(\bwhere\b\)\|\(\bwill\b\)//g' | sed 's/  */ /g;s/^ *//g;s/ *$//g;s/TASHA/YAR/g' | tr -c '0-9a-z\n' '-')
  filename="_posts/${when}-${slug}.md"

  cat > "${filename}" <<HERE
---
layout: post
title: Real Life in Star Trek, ${title}
date: ${when} ${HH}:${MM}:${SS}${TZ}
categories:
tags: [scifi, startrek, closereading]
summary: <i class="far fa-hand-spock"></i> The outside world in Star Trek
thumbnail: /blog/assets/eso0733a.png
teaser: For this episode, we need to talk about 
spell: 
---

* Ignore for ToC
{:toc}

![Still scanning the galaxy](/blog/assets/eso0733a.png "Still scanning the galaxy")

## Disclaimer

In these posts, we discuss a non-"Free as in Freedom" popular culture franchise property, including occasional references to part of that franchise behind a paywall.  My discussion and conclusions carry a Free Culture license, but nothing about the discussion or conclusions should imply any attack on the ownership of the properties.  All the big names serve as trademarks of the owners, and so forth, and everything here relies on sitting squarely within the bounds of [Fair Use](https://en.wikipedia.org/wiki/Fair_use), as criticism that uses tiny parts of each show to extrapolate the world that the characters live in.

## Previously...

I initially outlined the project [in this post]({% post_url 2020-01-02-trek-00 %}), for those falling into this from somewhere else.  In short, we attempt to use the details presented in *Star Trek* to assemble a view of what life looks like in the Federation.  This "phase" of the project changes from previous posts, however.  **The Next Generation** takes place long after the original series, so we shouldn't expect similar politics and socialization.  Maybe more importantly, I enjoy the series less.

In plain language, you shouldn't read this expecting a recap or review of an episode.  Many people have done both endlessly over nearly sixty years.  You *will* find a catalog of information that we learn from each episode, though, so expect everything to potentially "spoil" a story, if you happen to have that [irrational fear](https://www.theguardian.com/books/booksblog/2011/aug/17/spoilers-enhance-enjoyment-psychologists).

Rather than list every post in the series here, you can quickly find them all on [the *startrek* tag page](/blog/tag/startrek/).

## ${title}

HERE

tail --lines=+8 "$xscript" \
  | sed 's/ \[[0-9A-Za-z ]*\]: /: /g' \
  | sed "s/^\([0-9A-Z' ]*\): /**\1**: /g" \
  | sed 's/^/ >\n > /g' \
  >> "${filename}"

  cat >> "${filename}" <<HERE

## Conclusions



### The Good



### The Bad



### The Weird



## Next

Come back in a week, when 

#### <i class="far fa-hand-spock"></i>

* * *

**Credits**: The header image is []() by [](), made available under the terms of the [Creative Commons Attribution Share-Alike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
HERE

  sleep 5
  when=$(date --date="${when} +7 day" '+%F')
  rm "${xscript}"
done

