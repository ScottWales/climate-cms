climate-cms services
====================

Booting Nodes
-------------

Boot the master server 'puppet'

    ./scripts/master.sh

Boot an agent server

    ./scripts/agent.sh HOSTNAME

Servers will be configured with the puppet classes listed in
`hieradata/server/HOSTNAME.yaml`. Generally this will be a list of role
classes, which can be found in the repository under `local/roles/manifests`.

Servers
-------

### puppet

Puppetmaster server

### svn

Subversion mirror
