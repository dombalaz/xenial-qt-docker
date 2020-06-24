FROM ubuntu:xenial
MAINTAINER Dominik Baláž <dombalaz@pm.me>

ARG QT_VERSION=5.15.0

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/${QT_VERSION}/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
  build-essential \
  ca-certificates \
  git \
  libdbus-1-3 \
  libfontconfig1 \
  libgl1-mesa-dev \
  libice6 \
  libsm6 \
  libxext6 \
  libxkbcommon-x11-0 \
  libxrender1 \
  locales \
  openssh-client \
  pkg-config \
  sudo \
  wget \
  && apt-get clean

COPY qt-installer-noninteractive.qs /tmp/qt/

ARG QT_CI_LOGIN
ARG QT_CI_PASSWORD

RUN wget -q -O /tmp/qt/qt-installer.run http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run \
  && chmod +x /tmp/qt/qt-installer.run \
  && export QT_VERSION_PKG=`echo $QT_VERSION | awk 'BEGIN {FS="."} {print $1$2$3}'` \
  && /tmp/qt/qt-installer.run -platform minimal --verbose --script /tmp/qt/qt-installer-noninteractive.qs \
  && rm -rf /tmp/qt \
  && ls -d $QT_PATH/* | grep -v "$QT_VERSION" | xargs rm -r

RUN locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales

RUN adduser --disabled-password --shell /bin/bash --gecos "" user \
  && echo "user ALL= NOPASSWD: ALL" > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
