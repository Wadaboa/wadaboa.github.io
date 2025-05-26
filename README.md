[![Build Status](https://travis-ci.com/Wadaboa/wadaboa.github.io.svg?branch=release)](https://travis-ci.com/Wadaboa/wadaboa.github.io)

# My personal website

This repository hosts the code used to deploy my personal website, portfolio and blog, which is based on the Jekyll template [portfolYOU](https://github.com/YoussefRaafatNasry/portfolYOU) and uses GitHub Pages to automate everything. If you want to have a look, visit the link [alessiofalai.it](https://alessiofalai.it) or [wadaboa.github.io](https://wadaboa.github.io).

Credits to this [blog post](https://jogendra.dev/dockerize-your-jekyll-site-for-local-development) for the Docker setup.

## (0) Pre-requisites

First of all, make sure you have Docker installed. Then, build the image locally as follows.

```bash
docker build -t jekyll-site .
```

## (1) Serve

**"Serving" means testing changes locally. To do that, operate from the `develop` branch.**

To serve, run the container as follows.

```bash
docker run -it -p 4000:4000 -v "$PWD":/usr/src/app jekyll-site bash
```

Now execute the following command inside the Docker.

```bash
bundle exec jekyll serve --host 0.0.0.0 --watch
```

Once the server starts, open your browser and navigate to http://localhost:4000. You should see your Jekyll website running locally. Note that changes made to local files will automatically reflect on the website after a short automatic rebuild by Jekyll.

## (2) Build

**"Building" means preparing the changes for deployment. To do that, operate from the `release` branch.**

First of all, merge changes from the `develop` branch (the ones you tested via "Serving") using the following command.

```bash
git checkout release
git merge origin/develop
```

Now run the container as follows.

```bash
docker run -it -p 4000:4000 -v "$PWD":/usr/src/app jekyll-site bash
```

And then execute the following command inside the Docker, which will populate the `_site` folder.

```bash
bundle exec jekyll bundle
``` 

## (3) Deploy

**"Deploying" means publishing the changes online. To do that, operate from the `release` branch.**

To deploy, use the following command.

```bash
./deploy.sh
```

This will copy the `_site` folder content from the `release` branch into the `master` branch, which is what GitHub Pages uses to render the website.