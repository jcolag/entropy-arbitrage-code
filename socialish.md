---
layout: webmention
permalink: /socialish/
title: Social-ish Posts
---
{% assign social_posts = site.posts | where: "hidden", true %}
<h1>Social&hellip;ish for John Colagioia</h1>
<div class="home">
    {% for post in social_posts %}
      {% assign slug = post.name | split: '.' | first %}
      {% nest_index slug %}
    {% endfor %}
  <ul class="post-list">
  </ul>
</div>

<div class="pagination">
  {% if paginator.previous_page %}
    <a
      href="/blog/socialish{{ paginator.previous_page_path }}"
      class="previous"
    >
      <i class="fas fa-angle-double-left"></i>
      Newer Posts
    </a>
  {% else %}
    <span class="previous"></span>
  {% endif %}
  |
  <span class="page_number ">
    Page: {{ paginator.page }} of {{ paginator.total_pages }}
  </span>
  |
  {% if paginator.next_page %}
    <a
      href="/blog/socialish{{ paginator.next_page_path }}"
      class="next"
    >
      Older Posts
      <i class="fas fa-angle-double-right"></i>
    </a>
  {% else %}
    <span class="next "></span>
  {% endif %}
</div>

<p class="rss-subscribe"><a href="{{ "/pseudosocial.xml" | relative_url }}"><i class="fas fa-rss"></i> Subscribe via RSS</a></p>

