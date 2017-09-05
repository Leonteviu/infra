#!/bin/bash
git clone https://github.com/Artemmkin/reddit.git
cd reddit && bundle install
### export SERVER_IP=146.148.124.3
### export REPO_NAME=Leonteviu/reddit
### export DEPLOY_USER=appuser
puma -d
ps aux | grep puma
