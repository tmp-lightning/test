#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

ARG DC_TOKEN
ARG SPF_CID
ARG SPF_SECRET
ENV ENV_DC_TOKEN=$DC_TOKEN
ENV ENV_SPF_CID=$SPF_CID
ENV ENV_SPF_SECRET=$SPF_SECRET

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
  apt-get install -y curl git htop man unzip vim wget iputils-ping net-tools openssh-server sudo 

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
# BadGuy-Music-DiscordBot
#

# Install Python3.10
RUN \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt-get update && \
  apt-get install -y python3.10 python3.10-venv python3.10-dev 

# Install PIP
RUN \
  curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Install Dependency
RUN \
  apt-get install -y ffmpeg libxdamage1 xdg-utils fonts-liberation libnspr4 libnss3 libvulkan1 libxss1 libappindicator3-1 libindicator7 

# Download source code
RUN \
  git clone https://github.com/miracleexotic/BadGuy-Music-DiscordBot.git ./App/ && \
  python3 -m pip install -r ./App/requirements.txt

# Create Credential
RUN \
  mkdir -p ./App/authentication

RUN echo '{' >> ./App/authentication/config.json 
RUN echo '  "README": "Make a duplicate of this file and save it as config.json. Then configure the bot however you want",' >> ./App/authentication/config.json
RUN echo '  "token" : "'"$ENV_DC_TOKEN"'",' >> ./App/authentication/config.json
RUN echo '  "spotify": {' >> ./App/authentication/config.json
RUN echo '    "cid": "'"$ENV_SPF_CID"'",' >> ./App/authentication/config.json
RUN echo '    "secret": "'"$ENV_SPF_SECRET"'"' >> ./App/authentication/config.json 
RUN echo '  }' >> ./App/authentication/config.json 
RUN echo '}' >> ./App/authentication/config.json

CMD ["/usr/bin/supervisord"]

