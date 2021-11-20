[![Build Status](https://travis-ci.com/Wadaboa/wadaboa.github.io.svg?branch=release)](https://travis-ci.com/Wadaboa/wadaboa.github.io)

# My personal website

This repository hosts the code used to deploy my personal website, portfolio and blog.\
The website is based on the Jekyll template [portfolYOU](https://github.com/YoussefRaafatNasry/portfolYOU)
and uses GitHub Pages to automate everything.\
If you want to have a look, visit the link [alessiofalai.it](https://alessiofalai.it) or [wadaboa.github.io](https://wadaboa.github.io).

## Ruby version

Make sure that you are using Ruby 2.6.3. In order to avoid fiddling with system-level configurations, install [RVM](https://gist.github.com/denji/8706676) and then run `rvm install 2.6.3`.

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
