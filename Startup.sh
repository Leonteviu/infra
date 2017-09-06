#!/bin/bash
echo ######################## RUBY INSTALL #######################
cd /home/appuser
su - appuser -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
su - appuser -c "curl -sSL https://get.rvm.io | bash -s stable"
su - appuser -c "source ~/.rvm/scripts/rvm"
su - appuser -c "rvm requirements"
su - appuser -c "rvm install 2.4.1"
su - appuser -c "rvm use 2.4.1 --default"
su - appuser -c "gem install bundler -V --no-ri --no-rdoc"
# su - appuser -c "ruby -v"
# su - appuser -c "gem -v bundler"
echo ####################### MONGODB INSTALL ##########################
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
echo ######################## DEPLOY #################################
su - appuser -c "git clone https://github.com/Artemmkin/reddit.git"
su - appuser -c "cd reddit && bundle install && puma -d"
# ps aux | grep puma
