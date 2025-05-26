[![Build Status](https://travis-ci.com/Wadaboa/wadaboa.github.io.svg?branch=release)](https://travis-ci.com/Wadaboa/wadaboa.github.io)

# My personal website

This repository hosts the code used to deploy my personal website, portfolio and blog, which is based on the Jekyll template [portfolYOU](https://github.com/YoussefRaafatNasry/portfolYOU) and uses GitHub Pages to automate everything. If you want to have a look, visit the link [alessiofalai.it](https://alessiofalai.it) or [wadaboa.github.io](https://wadaboa.github.io).

Credits to this [blog post](https://jogendra.dev/dockerize-your-jekyll-site-for-local-development) for the Docker setup.

## (1) Serve

**"Serving" means testing changes locally. To do that, operate from the `develop` branch.**

First of all, make sure you have Docker installed. Then, build the Docker image and run the container as follows.

```bash
docker-compose -f docker-compose.serve.yml up --build
```

Once the server starts, open your browser and navigate to http://localhost:4000. You should see your Jekyll website running locally. Note that changes made to local files will automatically reflect on the website after a short automatic rebuild by Jekyll.

## (2) Build

**"Building" means preparing the changes for deployment. To do that, operate from the `release` branch.**

First of all, merge changes from the `develop` branch (the ones you tested via "Serving") using the following command.

```bash
git checkout release
git merge origin/develop
```

Now run the following Docker Compose command to build the website, which populates the `_site` folder.

```bash
docker-compose -f docker-compose.build.yml up --build
```

## (3) Deploy

**"Deploying" means publishing the changes online. To do that, operate from the `release` branch.**

To deploy, use the following command.

```bash
docker-compose -f docker-compose.deploy.yml up --build
```

This will rely on [`jgd`](https://github.com/yegor256/jekyll-github-deploy) to copy the `_site` folder content from the `release` branch into the `master` branch, which is what GitHub Pages uses to render the website.