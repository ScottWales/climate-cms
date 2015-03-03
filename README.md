<<<<<<< HEAD
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
=======
ARCCSS CMS Services
===================

Booting Nodes
-------------

Boot the master server (required before any others)

    ./boot puppet

Boot an agent server and register it with Puppet

    ./boot svn
    ssh admin@puppet sudo puppet cert sign svn

Servers will be configured with the puppet classes listed in
`hieradata/server/HOSTNAME.yaml`. Generally this will be a list of role
classes, which can be found in the repository under `local/roles/manifests`.

Servers
-------

### proxy

Web proxy server used to control external access

Requres external access on ports 80 and 443 to serve webpages

### puppet

Puppetmaster server used to configure other servers

Requires internal access on port 8140 so agents can receive their
configurations

### code

Code development tools such as Jenkins and Subversion

Requires access from proxy to port 8080 to provide web services

### data

Data management tools such as Thredds and Ramadda

Requires access from to port 8080 to provide web services
>>>>>>> puppetmaster
