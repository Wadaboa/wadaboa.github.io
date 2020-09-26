[![Build Status](https://travis-ci.com/Wadaboa/wadaboa.github.io.svg?branch=release)](https://travis-ci.com/Wadaboa/wadaboa.github.io)

# My personal website

This repository hosts the code used to deploy my personal website, portfolio and blog.\
The website is based on the Jekyll template [portfolYOU](https://github.com/YoussefRaafatNasry/portfolYOU)
and uses GitHub Pages to automate everything.\
If you want to have a look, visit the link [alessiofalai.it](https://alessiofalai.it) or [wadaboa.github.io](https://wadaboa.github.io).

## Build

In order to build the website locally, run:

```bash
bundle exec jekyll build
```

The build stage populates the `_site` folder, meaning that executing the command above is mandatory before pushing changes to the `release` branch.

If instead you want to test changes locally, just run:

```bash
bundle exec jekyll serve
```

This command will build the website and start a webserver at http://127.0.0.1:4000/. Remember that `serve` does not imply `build`.
