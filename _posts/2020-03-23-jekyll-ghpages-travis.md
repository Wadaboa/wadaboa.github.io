---
title: Jekyll + Github Pages + Travis CI
tags: [Web]
style: fill
color: warning
description: "A tutorial on how to build a static site using Jekyll and on how to automatically deploy it to Github Pages using Travis CI."
---

### Introduction

Have you ever heard of **static sites**? Well, if your answer is no, stick with me and you will learn the basics of them.

As defined on [Wikipedia](https://en.wikipedia.org/wiki/Static_web_page), a **flat page** is a web page that is delivered to the user's web browser exactly as stored, such that this page displays the same information for all users. Actually, _"exactly as stored"_ would be too restrictive to produce a decent website with minimal effort, and here is where **Jekyll** comes into play.

### What is Jekyll?

[Jekyll](https://jekyllrb.com/) is a tool used to generate simple, blog-aware, static websites. Let's analyze those words:

- **Simple**: The gist is that you don't have to deal with databases
- **Blog-aware**: Jekyll natively handles posts, categories, permalinks and more
- **Static**: The only files you should have to deal with are HTML, CSS and Markdown

Jekyll uses the so-called [`Liquid`](https://github.com/Shopify/liquid) template engine, developed by **Shopify**, which we can exploit to inject some logic into our static files. Liquid is based upon two types of markup:

- _Output_: A set of double curly braces containing an **expression**; when the template is rendered, it gets replaced with the value of that expression (e.g. `Hello {{ "{{ user.name " }}}}`)
- _Tag_: A set of matching curly braces and percent signs, used for the **logic** in your template (e.g. `{{ "{% if <CONDITION> " }}%} ... {{ "{% endif " }}%}`)

Jekyll has an extensive **theme system**, which we can leverage to build good-looking websites effortlessly. My personal favorite Github-hosted theme is [`PortfolYOU`](https://github.com/YoussefRaafatNasry/portfolYOU), which is the one I am using right now on the website you're on.

Jekyll sites can also be enriched by **plugins**. You can browse for some good ones [here](https://github.com/planetjekyll/awesome-jekyll-plugins). My personal favorites are the following ones:

- [`jemoji`](https://github.com/jekyll/jemoji): GitHub-flavored **emoji** plugin for Jekyll
- [`jekyll-remote-theme`](https://github.com/benbalter/jekyll-remote-theme): Jekyll plugin for building Jekyll sites with any GitHub-hosted theme
- [`jekyll-admin`](https://github.com/jekyll/jekyll-admin): A Jekyll plugin that provides users with a traditional **CMS-style graphical interface** to author content and administer Jekyll sites
- [`jekyll-sitemap`](https://github.com/jekyll/jekyll-sitemap): Jekyll plugin to silently generate a **sitemaps.org** compliant sitemap for your Jekyll site
- [`jekyll-analytics`](https://github.com/hendrikschneider/jekyll-analytics): Plugin to easily add **webanalytics** to your jekyll site. Currently Google Analytics, Piwik and mPulse are supported.

If you want to create a local Jekyll project you can open a command-line window and do the following:

1. Make sure you have `Ruby` installed on your system
2. Run `gem install bundler jekyll`
3. Run `jekyll new my-site && cd my-site`
4. Run `bundle exec jekyll serve`

This will run your `my-site` locally at `http://localhost:4000`, so that you can open a browser and see what's happening.

That's pretty much all you have to know to work with Jekyll. Next up, we have to host our website on a specific provider to make it accessible on the internet, and here is where **Github pages** comes in handy.

### What is Github pages?

[Github pages](https://pages.github.com/) is a free hosting service provided by the Github organization. With it, you can create one personal website with just a few clicks, which will be live at the URL `<username>.github.io`. To start, you have to do the following:

1. Create a public repository and name it `<username>.github.io`, where `<username>` is your lowercase Github username (e.g. my Github username is **Wadaboa** and my Github pages repo is named `wadaboa.github.io`)
2. Head over to the new repo settings and flag _"Enforce HTTPS"_ if it is unflagged. Then, optionally write a custom domain, other than `<username>.github.io`, inside the _"Custom domain"_ field (note that this will require to modify some [DNS settings](https://help.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site) on your custom domain provider)

You are good to go. Now, all you have to do is download a Jekyll theme, or build a Jekyll website from scratch, as described above, and upload those files to the `master` branch of your Github pages repo.

So, why is **Travis CI** needed if the entire deployment is already done by Github pages? We shall see where a **Continuos Integration** pipeline turns out useful in the next section.

### What is Travis CI?

[Travis CI](https://travis-ci.org/) is a tool used to automate some repetitive programming tasks, which fall under the category known as _DevOps_.

In our example, how could Travis CI help us? Well, if you are using a Jekyll Github-hosted remote theme and you want to **extend it** with new functionalities, such as new plugins, you may want to locally build your Jekyll project and then directly push the generated static files to Github pages, in order to let it serve those files without the need to perform **build operations**. This operation is actually needed when you want to work with **non-safe plugins**, i.e. plugins which are not supported by the build process of Github pages. Examples of such plugins are `jekyll-analytics` and `jekyll-sitemap`.

In order to work with Travis CI, we need to follow some simple steps:

- Head over to the [Travis CI website](https://travis-ci.org/) and sign-in using **Github**
- Click on your profile picture in the top right of your _Travis Dashboard_, click _Settings_ and then the green _Activate_ button, and select the repositories you want to use with Travis CI (in this example we have to select our `<username>.github.io`)
- On Github, click on your profile picture in the top right → _Settings_ → _Developer settings_ → _Personal access tokens_ → _Generate new token_, then add a _Travis CI_ entry with the `repo` scopes and copy the corresponding token
- On Travi CI, click on _Dashboard_ → `<username>.github.io` under _Active repositories_ → _More options_ → _Settings_ → _Environment Variables_ and set the variable `GITHUB_API_KEY` with value the **Github generated token**

Now, you need to create a `.travis.yml` file in the root of your `<username>.github.io` repository, with the following content:

```yml
language: ruby
rvm:
  - 2.6.3

before_install:
  - gem install bundler

install:
  - bundle install

before_script:
  - chmod +x ./scripts/build

script: ./scripts/build

branches:
  only:
    - release

sudo: required

cache: bundler

deploy:
  provider: pages
  skip_cleanup: true
  keep-history: true
  local_dir: _site/
  target_branch: master
  github_token: $GITHUB_API_KEY
  on:
    branch: release

notifications:
  email:
    on_success: never
    on_failure: always
```

You will also need to create a `build` script inside a new `scripts` folder, with the following content:

```bash
#!/usr/bin/env bash

set -e
JEKYLL_ENV=production bundle exec jekyll build --destination _site
touch ./_site/.nojekyll

```

In order to make everything work, you will also need to create two new branches:

- `develop`, which will contain **works-in-progress**, not ready to be published
- `release`, which will contain the **latest** published website

When you will perform a push on the `release` branch, Travis CI will be _triggered_ and your _build_ will start. If anything goes wrong, you will receive a **notification** on your Github-associated email, otherwise you will see a push on the `master` branch, made by `traviscibot`, and your updated website will be **live**.

Remember that the `master` branch is where Travis CI will copy the static files associated with your Jekyll website. These static files are generated inside the `_site` folder in the root of your project when you perform a `bundle exec jekyll build` operation and they should not be present in your `release` branch, hence you should always add `_site/` to your `.gitignore` file.

TEST 2
