FROM ubuntu:14.04

MAINTAINER morock

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
#ENV DEBIAN_FRONTEND readline

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# we don't need an apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# enable fancy dpkg progress bars
RUN echo "Dpkg::Progress-Fancy \"1\";" > /etc/apt/apt.conf.d/99progressbar

# https://people.debian.org/~hmh/invokerc.d-policyrc.d-specification.txt
# RUN printf '#!/bin/sh\nexit 101\n' > /usr/sbin/policy-rc.d
# RUN chmod +x /usr/sbin/policy-rc.d

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -s /bin/true /sbin/initctl

##
## Installs Android SDK
##

ENV ANDROID_SDK_VERSION r24.4.1
ENV ANDROID_BUILD_TOOLS_VERSION 23.0.2

# Installs i386 architecture required for running 32 bit Android tools
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y \
        curl \
        git \
        openjdk-7-jdk \
        libc6:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        lib32z1 \
        gradle \
        nodejs \
        npm \
        ruby \
    ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ; apt-get autoremove -y \
    ; apt-get clean

ENV ANDROID_SDK_FILENAME android-sdk_${ANDROID_SDK_VERSION}-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-19,android-20,android-21,android-22,android-23 
ENV ANDROID_HOME /opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

RUN cd /opt && \
    curl -O ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},extra-android-m2repository,extra-android-support

RUN ln -s /usr/bin/nodejs /usr/bin/node
## install Node Version Manager
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source ~/.profile
RUN nvm install v0.12.9
RUN npm install --global bower gulp cordova ionic
RUN cordova telemetry off
RUN gem install sass

COPY ./etc/bashrc /root/.bashrc

## entry point
COPY ./start.sh /start.sh

# ENTRYPOINT ["/bin/bash", "/start.sh"]]
CMD ["/bin/bash", "/start.sh"]

