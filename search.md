---
layout: page
permalink: /search/
---

<div id="search-container">
  <input
    autofocus
    id="search-input"
    placeholder="🔍 Search..."
    type="search"
  >
  <ul id="results-container"></ul>
</div>

<script
  src="/blog/js/simple-jekyll-search.js"
  type="text/javascript"
>
</script>

<script type="text/javascript">
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/blog/search.json'
});
var search = document.getElementById('search-input');
var string = window.location.href.split('?');
search.value = string.length > 1 ? decodeURI(string[1]) : '';
search.focus();
</script>
