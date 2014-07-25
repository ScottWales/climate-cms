ACCESS Subversion Mirror
========================

This Puppet configuration sets up the ACCESS subversion mirror at
https://svn.accessdev.nci.org.au.

The Puppet configuration is designed to work on a Centos 6.5 image on the NCI
Openstack cloud, but should work with minor modifications at any site.

The list of mirrored repositories is available at [hieradata/mirrors.yaml].

Configuration
-------------

System configuration uses Hiera. Any private information should be added to
[heiradata/svn.secure] or [heiradata/secure], these files should not be
committed to the repository. [heiradata/insecure] stores insecure secrets for
testing, copy this file & change the secrets to create a secure version.

 * System admin accounts are configured in [heiradata/admins.yaml]
 * Mirror sites are configured in [heiradata/svn.yaml]

Provisioning
------------

Boot the instance with

    scripts/boot.sh

Update the instance by sshing to the machine using an admin account and running

    sudo provision

Testing
-------

Install test dependencies with (requires bundler)

    bundle install --path .vendor

Run tests with

    bundle exec rake spec
