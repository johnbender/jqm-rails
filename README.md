# jQuery Mobile and Rails Sample

This is a simple office presence application that allows users to notify office mates of their intended absence from the office for a given day. The focus is on highlighting integration points between Rails and jQM like form validation refreshes and using AMD in the asset pipeline.

## Setup

There are two ways to set up this application for development. The easiest is with (Vagrant)[http://vagrantup.com] if you already have it installed.

    git clone github.com/repo/url.git
    vagrant up
    vagrant ssh
    cd /vagrant
    rails server

At which point your app can be viewed at http://33.33.33.10:3000 from the host machine or on the network at http://$NETWORK_IP:4567.

The second is to setup all the rails dependencies locally. If you happen to be running linux you can use the `script/provision.sh` file to install the package dependencies (_except_ ruby) including node.

    cd $PROJECT_DIR
    bash script/provision.sh

On other operating systems the development dependencies are left to the reader.

## Notes

The model and controler for the user authentication is borrowed from the show notes/code sample of (Railscast 270)[https://github.com/railscasts/episode-270/tree/master/auth-after] for the sake of saving time. Thanks Ryan!
