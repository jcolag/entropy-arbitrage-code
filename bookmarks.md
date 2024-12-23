---
layout: page
title: Saved Pages
permalink: /bookmarks/
show_page: false
---

<noscript>
## JavaScript Required

Sadly, this page won't do you much good without JavaScript enabled.
</noscript>

<script>
window.addEventListener('load', (e) => {
  let pages = localStorage.getItem('savedPages');

  if (!pages) {
    pages = [];
  } else {
    pages = JSON.parse(pages);
  }

  pages.forEach((p) => {
    const row = document.createElement('tr');
    const linkC = document.createElement('td');
    const dateC = document.createElement('td');
    const stopC = document.createElement('td');
    const link = document.createElement('a');
    const when = new Date(p.time);
    const date = document.createTextNode(when.toString());
    const title = document.createTextNode(p.title);
    const table = document.getElementById('saved-pages');

    link.href = p.url;
    link.appendChild(title);
    linkC.appendChild(link);
    dateC.appendChild(date);
    row.appendChild(linkC);
    row.appendChild(dateC);
    row.appendChild(stopC);
    table.appendChild(row);
  });
});
</script>

<table id="saved-pages">
  <tr>
    <th>Page Link</th>
    <th>Date Saved</th>
    <th>Stop Saving</th>
  </tr>
</table>

Note that the page-saving system stores your pages in your browser's local
storage.  This means that **Entropy Arbitrage** does not and cannot access
this information.
