FROM ubuntu:14.04
MAINTAINER kazu69 "kazu.69.web+docker@gmail.com"

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.3.0

RUN apt-get -y update
RUN apt-get -y install curl \
                        git \
                        wget \
                        build-essential \
                        libssl-dev \
                        libqt4-dev \
                        libqtwebkit-dev \
                        xvfb \
                        dbus \
                        libffi-dev \
                        mysql-client \
                        libxml2-dev \
                        libgcrypt-dev \
                        libxslt-dev \
                        libreadline-dev \
                        chrpath \
                        libxft-dev \
                        libfreetype6 \
                        libfreetype6-dev \
                        libfontconfig1 \
                        libfontconfig1-dev \
                        libmysqlclient-dev

RUN git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc

RUN rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION

RUN gem install bundler

# install package for phantomjs
ENV PHANTOMJS_VERSION="phantomjs-1.9.8"
ENV PHANTOMJS="$PHANTOMJS_VERSION-linux-x86_64"
ENV PHANTOMJS_DOWNLOAD_SHA256="a1d9628118e270f26c4ddd1d7f3502a93b48ede334b8585d11c1c3ae7bc7163a"
ENV PHANTOMJS_DOWNLOAD_URL="https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS.tar.bz2"

RUN mkdir -p /tmp/phantomjs && \
    cd /tmp/phantomjs && \
    wget $PHANTOMJS_DOWNLOAD_URL

RUN cd /tmp/phantomjs && \
    echo "$PHANTOMJS_DOWNLOAD_SHA256  /tmp/phantomjs/$PHANTOMJS.tar.bz2" | sha256sum -c - && \
    tar xjf /tmp/phantomjs/$PHANTOMJS.tar.bz2 && \
    ln -snf /tmp/phantomjs/$PHANTOMJS/bin/phantomjs /usr/local/bin/phantomjs
