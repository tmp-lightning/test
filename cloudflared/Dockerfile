#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

ARG CF_TOKEN
ENV ENV_CF_TOKEN=$CF_TOKEN

#
# Initial OS
#

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git htop man unzip vim wget iputils-ping openssh-server sudo 

# Supervisord 
RUN \
  apt-get update && \
  apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 
RUN echo 'test:test' | chpasswd
RUN echo 'test ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers
RUN service ssh start
EXPOSE 22

#
# Cloudflared Proxy
#

# Install Cloudflared
RUN \
  curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
  dpkg -i cloudflared.deb

CMD ["/usr/bin/supervisord", $ENV_CF_TOKEN]



# COPY ./script .

# RUN chmod 755 ./script

# ---
# Start Tunnel
# CMD ./script $ENV_CF_TOKEN
# ---

