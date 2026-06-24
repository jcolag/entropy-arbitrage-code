{%- comment -%}
  include.media: preference of media consumption for the month
    For example, a history/heritage month or holiday
    Optional
  include.preview: the upcoming/old project highlighted in the newsletter
    Can be vague, such as "another mostly abandoned project"
  include.topics: pipe-delimited list of subjects written about
{%- endcomment -%}
{%- assign month = page.date | date: "%B" -%}
{%- assign date = page.date | first_w_of_month: 2 -%}
{%- assign day = date | date: "%e" | plus: 0 -%}
{%- assign topic_array = include.topics | split: '|' -%}
{%- assign topics = topic_array | array_to_sentence_string -%}

## Entropy Arbitrage Newsletter

For those of you interested in such things, I'll have the {{ month }} issue of the [**Entropy Arbitrage** newsletter](https://www.buymeacoffee.com/jcolag) ready to go on Tuesday the {{ day | ordinal_word }}
{%- if day > 7 or day == 1 -%}
  {{ ", also known as tomorrow, for the calendrically impaired" }}
{%- endif -%}.
If you'd like it delivered, head to that link, click the <i class="fas fa-ellipsis-h"></i> ellipsis at the upper-right, then **Follow**, and give the form your e-mail address; no money involved, despite the site name, and I have no access to the list, if you'd rather not make yourself known.
{% if day > 1 and day < 7 -%}
  {%- assign mon = day | minus: 1 | ordinal_word -%}
  You'll probably see a brief reminder next week on the {{ mon -}}.
{%- endif %}

What will you find inside?  As always, you'll find links to all the articles that I found interesting in my RSS feed or web pages that I bookmarked, plus some analysis of blog traffic.  For {{ month }}, I wrote
{% if topic_array.size == 1 -%}
  a piece
{% else -%}
  pieces
{%- endif %}
on {{ topics }}, discussed my media consumption
{%- if include.media -%}
  {{- " " -}}
  tipped a bit in the direction of
  {{ include.media -}}
{%- endif -%}, and provided some background information on {{ include.preview -}}.  If you've become a *member* on Buy Me a Coffee, then you have probably already seen previews for some of that.

And if you'd like to see what that has looked like in practice, or if you already have too much in your inbox, then you can read old installments from the [newsletter archive](https://buymeacoffee.com/jcolag/posts/71215), which goes back as far as issue #23 in May 2022, when I started using Buy Me a Coffee.  Prior to that, I only used Mailchimp, so the remaining archive lives over there, somewhere.

