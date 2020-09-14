---
layout: page
permalink: /search/
---

<div id="search-container">
  <input
    autofocus
    id="search-input"
    placeholder="🔍 Search..."
    type="text"
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
})
</script>
