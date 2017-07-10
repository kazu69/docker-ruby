FROM kazu69/alpine-base
MAINTAINER kazu69

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.4.1

RUN apk --update del openssl-dev && \
    apk add linux-headers \
            imagemagick-dev \
            qt-webkit \
            xvfb \
            mariadb-dev \
            mysql-client \
            autoconf \
            bison \
            bzip2 \
            bzip2-dev \
            ca-certificates \
            coreutils \
            gcc \
            gdbm-dev \
            glib-dev \
            libc-dev \
            libffi-dev \
            libxml2-dev \
            libxslt-dev \
            make \
            ncurses-dev \
            openssl \
            procps \
            readline-dev \
            ruby \
            tar \
            yaml-dev \
            zlib-dev \
    && rm -rf /var/cache/apk/*

 RUN git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

 RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
     echo 'eval "$(rbenv init -)"' >> /root/.bashrc

 RUN rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION

 RUN gem install bundler

# see https://github.com/Overbryd/docker-phantomjs-alpine/releases/tag/2.11
# install phantomjs 2.1.1
ENV PHANTOM_VERSION 2.11
RUN apk update && apk add --no-cache fontconfig && \
  mkdir -p /usr/share && \
  cd /usr/share && \
  curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/${PHANTOM_VERSION}/phantomjs-alpine-x86_64.tar.bz2 | tar xj && \
  ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs && \
  phantomjs --version
