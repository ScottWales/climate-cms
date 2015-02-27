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

### puppet

Puppetmaster server

### svn

Subversion mirror
