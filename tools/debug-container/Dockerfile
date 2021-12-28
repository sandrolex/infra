FROM ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl jq python3 dnsutils iputils-ping iputils-arping telnet

RUN echo "debug-container:1" > /root/version.txt
