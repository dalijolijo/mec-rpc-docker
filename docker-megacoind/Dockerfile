FROM ubuntu:18.04 
LABEL maintainer="LIMXTEC developer"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp
COPY ./CHECKSUM /tmp

RUN apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  apt-utils \
                        autoconf \
                        automake \
                        autotools-dev \
                        build-essential \
                        libboost-all-dev \
                        libevent-dev \
                        libminiupnpc-dev \
                        libssl-dev \
                        libtool \
                        libzmq5-dev \
                        pkg-config \
                        software-properties-common \
                        wget && \
    add-apt-repository -y ppa:bitcoin/bitcoin && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y  libdb4.8-dev \
                        libdb4.8++-dev

RUN VERSION=`cat /tmp/VERSION` && \
    wget https://github.com/dalijolijo/Megacoin/releases/download/${VERSION}/megacoin-x86_64-linux-gnu_no-wallet.tar.gz -O /tmp/prebuilt.tar.gz
RUN sha256sum /tmp/prebuilt.tar.gz && \
    echo "$(cat /tmp/CHECKSUM)  /tmp/prebuilt.tar.gz" | sha256sum -c
RUN ls /tmp && \
    tar xzf /tmp/prebuilt.tar.gz -C /tmp/
RUN mv /tmp/bin/megacoind /usr/local/bin && \
    mv /tmp/bin/megacoin-cli /usr/local/bin && \
    mv /tmp/bin/megacoin-tx /usr/local/bin && \
    chmod a+x /usr/local/bin/*
RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV DATA /data
WORKDIR /data

EXPOSE 7951 7952

ENTRYPOINT ["init"]
