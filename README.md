climate-cms
===========

A cloud cluster for supporting climate scientists

Bootstrapping
-------------

The bootstrap script will setup a controller node with Foreman/Puppetmaster for
other nodes to configure themselves from.

Boot a test VM using Vagrant using

    vagrant up

Configure an existing Centos VM with

    curl https://github.com/ScottWales/bootstrap.sh | sudo bash

Nodes
-----

See hieradata/nodes

 * controller: Cloud admin. Includes Foreman, Puppetmaster, Puppetdb
 * code: Code-development. Includes Phabricator, Jenkins
 * data: Data management. 
