cd /vagrant

# setup for the javascript runtime
sudo apt-get update
sudo apt-get install -qq python-software-properties
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update

# install dependent packages
apt-get install -qq sqlite3 libsqlite3-dev nodejs

# sort out the dependencies
gem install bundler
bundle install