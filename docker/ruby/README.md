## Ruby Dockerfile


This **Dockerfile** contains instructins for building a [Docker](https://www.docker.com/) image for [Ruby](https://www.ruby-lang.org/). The Ruby version is configured through the `RUBY_VERSION` environment variable (set to 2.2.3 by default).


### Base Docker Image

* [centos:centos6](https://hub.docker.com/_/centos/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Build an image from Dockerfile: `docker build -t centos6-ruby2.2.3`


#### Run `ruby`

    docker run -it --rm centos6-ruby2.2.3 ruby
