#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04

ARG CF_TOKEN
ARG DC_TOKEN
ARG SPF_CID
ARG SPF_SECRET
ENV ENV_CF_TOKEN=$CF_TOKEN
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
  apt-get install -y curl git htop man unzip vim wget iputils-ping openssh-server sudo 

# Cloudflared
RUN \
  curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
  dpkg -i cloudflared.deb

# SSH
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 
RUN echo 'test:test' | chpasswd
RUN echo 'test ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers
RUN service ssh start
EXPOSE 22

COPY ./script .

RUN chmod 755 ./script

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
  apt-get install -y tmux ffmpeg

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

# Run in tmux
#RUN \
#  tmux new-session -s App -d "python3 ./App/main.py"

# ---
# Start Tunnel
CMD ./script $ENV_CF_TOKEN
# ---

