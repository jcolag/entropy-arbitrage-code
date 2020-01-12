# entropy-arbitrage-code

This is a repository for the Jekyll side of the posts found in [entropy-arbitrage](https://github.com/jcolag/entropy-arbitrage).

For reference, this is mostly for transparency and I don't recommend using this directly *at all*, since it's deliberately built around my website's design.  The `about.md` and header/footer also refer rather directly to me, of course, in addition to configuration and the like.

## Assets

Because it's a lot, I've opted not to include the `assets` folder, which includes not just the images used in the blog (originals linked to in the posts), but also fonts, JavaScript, and CSS bits.  Here's the layout, minus images:

```
├── Exo2-Light.ttf
├── fa
│   ├── css
│   │   ├── all.css
│   │   ├── all.min.css
│   │   ├── brands.css
│   │   ├── brands.min.css
│   │   ├── fontawesome.css
│   │   ├── fontawesome.min.css
│   │   ├── regular.css
│   │   ├── regular.min.css
│   │   ├── solid.css
│   │   ├── solid.min.css
│   │   ├── svg-with-js.css
│   │   ├── svg-with-js.min.css
│   │   ├── v4-shims.css
│   │   └── v4-shims.min.css
│   └── webfonts
│       ├── fa-brands-400.eot
│       ├── fa-brands-400.svg
│       ├── fa-brands-400.ttf
│       ├── fa-brands-400.woff
│       ├── fa-brands-400.woff2
│       ├── fa-regular-400.eot
│       ├── fa-regular-400.svg
│       ├── fa-regular-400.ttf
│       ├── fa-regular-400.woff
│       ├── fa-regular-400.woff2
│       ├── fa-solid-900.eot
│       ├── fa-solid-900.svg
│       ├── fa-solid-900.ttf
│       ├── fa-solid-900.woff
│       └── fa-solid-900.woff2
├── fa-regular-400.ttf
├── fa-solid-900.ttf
├── NotoColorEmoji.ttf
├── prism.css
├── prism.js
└── Vollkorn-Bold.ttf
```

It would probably be smart to separate the two different kinds of assets, at some point.
