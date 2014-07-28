ACCESS Subversion Mirror
========================

This Puppet configuration sets up the ACCESS subversion mirror.

The Puppet configuration is designed to work on a Centos 6.5 image on the NCI
Openstack cloud, but should work with minor modifications at any site.

Configuration
-------------

System configuration uses Hiera. Any private information should be added to
`hieradata/$HOSTNAME.private.yaml` or `hieradata/private.yaml` on the server
itself, these files should not be committed to the repository.
[hieradata/insecure.yaml](hieradata/insecure.yaml) stores insecure secrets for
testing, copy this file & change the secrets to create a secure version.

 * System admin accounts are configured in
   [hieradata/admins.yaml](hieradata/admins.yaml). Only users listed here will
   have sudo access on the system.

 * Mirror sites are configured in
   [hieradata/$HOSTNAME.yaml](hieradata/svn.yaml)

 * Puppet defaults are set in [hieradata/common.yaml](hieradata/common.yaml)

Provisioning
------------

If running on an openstack cloud you can use `scripts/boot.sh` to boot an
instance with Nova. This will automatically download the repository from Github
& run Puppet. To manually install clone the repository to
`/etc/puppet/environments/production`, install Puppet & Librarian-Puppet then
run `sudo modules/site/files/provision.sh` (This should be run only on a fresh
machine, it will wipe any existing Apache and Sudo configuration).

Update the instance by sshing to the machine using an admin account and running
`sudo provision`

Testing
-------

The tests check service availability and security by connecting to three
servers by ssh:
 
 - 'server' is the mirror server running Apache
 - 'client' is a client machine where users will run svn commands
 - 'external' is a machine that shouldn't have unauthenticated access to the
   repository

The hostnames of each of these machines should be configured in
`spec/properties.yaml`

Install test dependencies with (requires Ruby & Bundler) `bundle install --path
.vendor`

Run tests with `bundle exec rake`

What it Does
------------

The Puppet manifest applies two classes - `::site` and `::roles::svnmirror`.
`[::site](modules/site/manifests/init.pp)` sets up site-specific configuration,
and should be modified for your environment.
`[::roles::svnmirror](modules/roles/manifests/svnmirror.pp)` sets up a
write-through Subversion mirror proxy using Apache and `mod_dav_svn`.
