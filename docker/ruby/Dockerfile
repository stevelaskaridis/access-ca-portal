FROM            centos:centos6

MAINTAINER      NicolasLiampotis

ENV             RUBY_VERSION 2.2.3

RUN             yum -y install \
                  vim \
                  git \
                  tar \
                  postgresql-devel \
                  epel-release
RUN             yum clean all
RUN             yum -y install \
                  nodejs
RUN             yum clean all

RUN             gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
                curl -sSL https://get.rvm.io | bash -s stable --ruby="$RUBY_VERSION"

RUN             bash -lc "rvm use $RUBY_VERSION && rvm gemset create app-env"
RUN             bash -lc "rvm use $RUBY_VERSION@app-env --default"
RUN             bash -lc "gem install bundler"

ONBUILD RUN     mkdir -p /opt/app
ONBUILD COPY    Gemfile /opt/app/
ONBUILD COPY    Gemfile.lock /opt/app/
ONBUILD WORKDIR /opt/app
ONBUILD RUN     bash -lc 'bundle install'
