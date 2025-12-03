---
layout: page
permalink: /tag-search/
---

<div id="search-modal">
  <div>
    <img class="fa-spin spinner" src="/blog/assets/jc.svg">
    <br>
    Please Wait
    <noscript>
      <hr>
      <p style="font-size: 0.6em;">
        Actually, search won't work without JavaScript enabled, nor will
        this modal box ever go away, so maybe don't wait&hellip;
      </p>
    </noscript>
  </div>
</div>
<div id="search-container" style="float: left; width: 49%">
{%- assign posts = site.posts -%}
{%- assign default_paths = site.pages | map: "path" -%}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
    {%- assign title = my_page.title | split: " " -%}
    {%- if title[0] == 'Tag-' -%}
      {%- assign count = 0 -%}
      {%- assign tag = title[1] | remove: ',' -%}
      {%- for post in posts -%}
        {%- assign labels = post.labels | join: "&" | prepend: "&" -%}
        {%- assign tags = post.tags | join: "&" | append: labels | split: "&" -%}
        {%- for t in tags -%}
          {%- assign tt = t | remove: '-' -%}
          {%- if tt == tag -%}
            {%- assign count = count | plus: 1 -%}
          {%- endif -%}
        {%- endfor -%}
      {%- endfor -%}
      <div class="tag-filter">
        <input
          id="ck-{{tag}}"
          onclick="toggleTag(this,'{{tag}}')"
          type="checkbox"
        >
        <label for="ck-{{tag}}">
          {{tag}}
          ({{ count }})
        </label>
      </div>
    {%- endif -%}
  {%- endif -%}
{%- endfor -%}
</div>
<div id="search-results" style="float: right; width: 49%">
</div>

<script type="text/javascript">
const posts = [
  {%- for post in site.posts -%}
    {%- assign labels = post.labels | join: ';' | prepend: ';' -%}
    {%- assign tags = post.tags | join: ';' | append: labels | remove: "-" | split: ';' | sort_natural -%}
    {
      "date":"{{ post.date }}",
      "id":"ck-{{tag}}",
      "summary":"{{ post.summary | strip_html | escape }}",
      "tags":["{{ tags | join: '","' }}"],
      "teaser":"{{ post.description | escape }}",
      "title":"{{ post.title | strip_html | escape }}",
      "url":"{{ site.baseurl }}{{ post.url }}"
    }{%- unless forloop.last -%},{%- endunless -%}
  {%- endfor -%}
];
const searchTarget = [];
function visibility(el, visible) {
  const parent = el.parentElement;

  if (!parent.classList.contains('tag-filter')) {
    return;
  }

  parent.style['display'] = visible ? '' : 'none';
}
function unHTML(html) {
  const txt = document.createElement('textarea');
  txt.innerHTML = html;
  return txt.value;
}
function toggleTag(el, tag) {
  const checks = Array.prototype.slice.call(document.getElementsByTagName('input'));
  const out = document.getElementById('search-results');
  const matchingPosts = [];
  let workingTags = [];

  if (el.checked) {
    searchTarget.push(tag);
  } else {
    const index = searchTarget.indexOf(tag);
    if (index > -1) {
      searchTarget.splice(index, 1);
    }
  }

  while (out.firstChild) {
    out.removeChild(out.lastChild);
  }

  checks.forEach((cb) => {
    visibility(cb, false);
  });

  if (searchTarget.length === 0) {
    checks.forEach((cb) => {
      visibility(cb, true);
    });

    return;
  }

  posts.forEach((p) => {
    if (searchTarget.every((t) => p.tags.includes(t))) {
      const date = new Date(p.date).toDateString();
      const li = document.createElement('div');
      const a = document.createElement('a');
      const title = document.createTextNode(unHTML(p.title));
      const other = document.createTextNode(unHTML(`, ${p.summary} (${date})`));

      a.appendChild(title);
      a.href = p.url;
      li.appendChild(a);
      li.appendChild(other);
      li.title = unHTML(p.teaser);
      out.appendChild(li);
      workingTags = workingTags.concat(p.tags);
    }
  });

  workingTags
    .forEach((t) => {
      const cb = document.getElementById(`ck-${t}`);

      if (cb) {
        visibility(cb, true);
      }
    });
}
window.addEventListener("load", (e) => {
  var modal = document.getElementById('search-modal');
  modal.style.display = 'none';
});
</script>
