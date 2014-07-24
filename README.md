ACCESS Subversion Mirror
========================

This Puppet configuration sets up the ACCESS subversion mirror at
https://svn.accessdev.nci.org.au.

The Puppet configuration is designed to work on a Centos 6.5 image on the NCI
Openstack cloud, but should work with minor modifications at any site.

The list of mirrored repositories is available at [hieradata/mirrors.yaml].

Provisioning
------------

Boot the instance with

    scripts/boot.sh

Update the instance with

    scripts/provision.sh

Testing
-------

Run tests (requires bundler) with

    scripts/test.sh
