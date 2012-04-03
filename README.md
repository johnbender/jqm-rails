# jQuery Mobile and Rails Sample

This is a simple office presence application that allows users to notify office mates of their intended absence from the office for a given day. The focus is on highlighting integration points between Rails and jQM like form validation refreshes and using AMD in the asset pipeline.

## Setup

There are two ways to set up this application for development. The easiest is with (Vagrant)[http://vagrantup.com] if you already have it installed.

    git clone github.com/repo/url.git
    vagrant up
    vagrant ssh
    cd /vagrant
    rails server

The second is to setup all the rails dependencies locally. If you happen to be running linux you can use the `script/provision.sh` file to install the package dependencies (_except_ ruby) including node.

    cd $PROJECT_DIR
    bash script/provision.sh

On other operating systems the development dependencies are left to the reader.
