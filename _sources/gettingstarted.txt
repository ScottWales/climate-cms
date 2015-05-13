Getting Started
===============

These are the main services used to configure servers in the climate-cms cloud:

puppet
------

Servers in the climate-cms cloud are configured using `Puppet
<http://docs.puppetlabs.com/puppet/>`_. Puppet handles installing software,
setting up configuration files and starting services.

Puppet code is collected into modules, which generally are designed to install
and configure a sepecific piece of software. For instance the
``puppetlabs-apache`` module installs and configures the Apache web server. The
climate-cms cloud uses a variety of modules, both defined locally (found in the
``local/`` directory of this repository) and from the central repository
`Puppet Forge <https://forge.puppetlabs.com/>`_ (listed in the file
``Puppetfile``).

Puppet starts at the file ``manifests/site.pp``, which decides what modules to
install on a server based on the Hiera configuration.

hiera
-----

The modules that get installed on a server are defined by a tool called `Hiera
<http://docs.puppetlabs.com/hiera/1/>`_. Hiera configuration files are found in
the ``hieradata/`` directory.

Hiera creates the configuration for a server by combining multiple config files
based on properties of the server. The climate-cms cloud has a fairly simple
setup - Hiera will look in the following files for configuration data, in order
of precedence:

 * ``server/$HOSTNAME.yaml``
 * ``private.yaml``
 * ``common.yaml``

The ``server/`` directory holds configuration specific to each server in the
cloud. ``private.yaml`` is not part of this repository, it holds private data
like passwords and keys and exists only on the Puppet server. ``common.yaml``
lists Puppet classes that get installed on all servers in the cloud.

salt
----

`Salt <http://docs.saltstack.com/en/latest/>`_ is a tool for running commands
on multiple servers at once. You can for example run::

    sudo salt '*' puppet.run agent test

to do a Puppet run on all servers, or::

    sudo salt 'web*' service.restart httpd

to restart Apache on web servers.

Salt also includes a configuration service similar to Puppet, we use Puppet for
compatibility with other NCI systems.
