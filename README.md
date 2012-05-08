# jQuery Mobile and Rails Sample

This is a simple office presence application that allows users to notify office mates of their intended absence from the office for a given day. The focus is on highlighting integration points between Rails and jQM like form validation refreshes and using AMD in the asset pipeline.

## Setup

There are two ways to set up this application for development. The easiest is with [Vagrant](http://vagrantup.com). You can install Vagrant by [downloading](http://downloads.vagrantup.com/tags/v1.0.3) and running the appropriate installation package. Alternatively you can use the traditional method of manual dependency management.

### Vagrant

Once Vagrant is installed using one of the downloaded packages you'll need to add a base box to build from (300mb), cclone the repo, and tell vagrant to build your development environment.

    vagrant box add base http://files.vagrantup.com/lucid32.box
    git clone git://github.com/johnbender/jqm-rails.git
    cd jqm-rails
    vagrant up

If the environment provisioning fails you can try again with

    vagrant provision

Assuming the environment provisioning succeeds your project directory will be available inside the VM at which point you can issue the following to enter the VM and start up the rails built in server.

    vagrant ssh
    cd /vagrant
    # an `ls` will show your project directory here
    rails server

At this point your app can be viewed at http://33.33.33.10:3000 from the host machine or on the network at http://$NETWORK_IP:4567.

### Manual Setup

The alternative method is to setup Rails directly on your workstation. If you happen to be running Ubuntu you can use the `script/provision.sh` file to install the package dependencies (_except_ ruby) including node, but make sure to review the script to verify what will be installed on your system.

    cd jqm-rails
    bash script/provision.sh

Otherwise you'll need to install bundler and the bundled gems with:

    cd jqm-rails
    gem install bundler # or `sudo gem install bundler`
    bundle install --path=./.bundle

This may fail to install if the sqlite3 development headers aren't available to compile the native extensions of the gem or if a compatible compiler isn't installed. Assuming success you can start up the application with:

    bundle exec rails server

Your application will be available at [http://localhost:3000/](http://localhost:3000)

## Teardown

### Vagrant

The Vagrant environments are disposable.

    cd jqm-rails
    vagrant destroy

### Other

Otherwise, if you follow the manual set of setup instructions you can remove the the project and gems in one fel swoop with

    rm -Rf jqm-rails

But any dependencies that you installe globally will have to be cleaned up manually.

## Notes

The model and controllers for the user authentication are borrowed from the show notes/code samples of [Railscast 270](https://github.com/railscasts/episode-270/tree/master/auth-after) for the sake of time savings. Thanks Ryan!
