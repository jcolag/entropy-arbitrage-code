# entropy-arbitrage-code

This repository holds the Jekyll side of the posts found in [entropy-arbitrage](https://github.com/jcolag/entropy-arbitrage).

For reference, this mostly exists for transparency, and I don't recommend using this directly *at all*, since I deliberately built it around my website's design.  The `about.md` and header/footer also refer rather directly to me, as a superficial inspection shows, in addition to configuration and the like.

## Assets

Because it contains a lot, I've opted not to include the `assets` folder---which includes not only the images used in the blog, originals linked to in the posts---but also fonts, JavaScript, and CSS bits.  You can see the layout here, minus images:

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
├── redirect.js
└── Vollkorn-Bold.ttf
```

The `fa` material, as you may guess, comes from [Font Awesome 5](https://fontawesome.com/).  The files named `prism.*` come from [Prism.js](https://prismjs.com/index.html), used for syntax highlighting of code snippets.  The fonts come from multiple common sources.

It would probably make sense to separate the two different kinds of assets---images and utility content---at some point.

For my own convenience, though, and usable to anybody who needs it, I finally created [a repository for the assets](https://gitlab.com/jcolag/entropy-arbitrage-assets), which sees updates weekly or so, generally Tuesday nights unless something goes wrong.

