---
layout: page
permalink: /search/
---

<div id="search-container">
  <input type="text" id="search-input" placeholder="🔍 Search...">
  <ul id="results-container"></ul>
</div>

<script
  src="/blog/js/simple-jekyll-search.js"
  type="text/javascript"
>
</script>

<script>
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/blog/search.json'
})
</script>
