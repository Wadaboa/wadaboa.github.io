# Use a slim Ruby image as the base
FROM ruby:2.6.3-slim

# Set environment variables for UTF-8 encoding and non-interactive package installation
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the source code
COPY . .

# Install Bundler and project dependencies
RUN gem install bundler -v 2.4.22 && bundle install

# Install Jekyll Github Deploy
RUN gem install jgd
