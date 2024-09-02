#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

ARG TOKEN

RUN export TOKEN=$TOKEN

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git htop man unzip vim wget iputils-ping && \
  rm -rf /var/lib/apt/lists/*

RUN \
  curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
  dpkg -i cloudflared.deb 
  

ENTRYPOINT ["cloudflared", "tunnel", "--no-autoupdate", "run", "--token", $TOKEN]


