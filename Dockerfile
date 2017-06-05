# This file describes how to build Hipache into a runnable linux container with
# all dependencies installed.
#
# To build:
#
# 1) Install docker (http://docker.io)
# 2) Clone Hipache repo if you haven't already: git clone https://github.com/dotcloud/hipache.git
# 3) Build: cd hipache && docker build .
# 4) Run: docker run -d --name redis redis
# 5) Run: docker run -d --link redis:redis -P <hipache_image_id>
#
# See the documentation for more details about how to operate Hipache.

# Latest Ubuntu LTS
from    ubuntu:14.04

# Update
run apt-get -y update

# Install node and npm
run apt-get update && apt-get -y install curl nodejs npm

# Upgrade nodejs for ECDHE support
run npm install -g n
run n v0.12.18
run ln -sf /usr/local/n/versions/node/0.12.18/bin/node /usr/bin/nodejs

# Manually add Hipache folder
run mkdir ./hipache
add . ./hipache

# Then install it
run npm install -g ./hipache --production

# This is provisional, as we don't honor it yet in Hipache
env NODE_ENV production

# Create Hipache log directory
RUN mkdir -p /var/log/hipache

# Add run.sh start script
copy run.sh /run.sh
run chmod u+x /run.sh

# Expose Hipache
expose  80

# Start supervisor
cmd [ "/run.sh" ]
