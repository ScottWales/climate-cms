Puppet Classes
==============

The local Puppet classes mainly act as glue to bring together external modules
from the Puppet Forge. They set up default arguments, open firewall ports and
configure service monitoring and backups

Servers
-------

server::apache
^^^^^^^^^^^^^^

Apache is a web server. All incoming web connections go through an Apache
server for encryption, logging and access control

server::elasticsearch
^^^^^^^^^^^^^^^^^^^^^

Elasticsearch is a flexible data storage and search tool. It is used for
accessing system logs alongside Logstash and Kibana.

server::icinga
^^^^^^^^^^^^^^

Icinga is a service that checks the condition of servers. It can check if the
disk is full, or make sure other services are running.

The web interface for icinga is available at ``/admin/icinga``

server::jenkins
^^^^^^^^^^^^^^^

Jenkins is a server for automatically building software and running tests.

The web interface for Jenkins is available at ``/jenkins``

server::proxy
^^^^^^^^^^^^^

The Proxy class sets up an Apache host and is responsible for wiring together
web services. Web services requesting a connection using
``client::proxy::connection`` are gathered together here.

server::puppet
^^^^^^^^^^^^^^

The Puppet server hosts the central configuration for all servers. Puppet
clients connect to it to work ou what changes need to be made to their servers.

The Puppet server class also installs PuppetDB, which Puppet uses to check what
state the clients are in, and R10K, which is used to update the Puppet
configuration.

server::ramadda
^^^^^^^^^^^^^^^

Ramadda is a web service for managing and sharing data. Ramadda is set up so
that it can serve data in NCI's ``/g/data`` storage

The web interface for Ramadda is available at ``/repository``

server::salt
^^^^^^^^^^^^

Salt is a service for running commands on many servers at the same time.
Commands given on the Salt server can be run on all or a selection of the
servers in the climate-cms cloud. This is used primarily for configuration
updates by performing a dry run of Puppet on all servers.

server::tomcat
^^^^^^^^^^^^^^

Tomcat is a server for running Java web programs. It is used by many of the
data tools, such as Thredds and Ramadda. Access to the Tomcat server is via an
Apache proxy.

Clients
-------

Clients are generally installed on multiple hosts and talk to a server. These
classes install client software and open up internal firewall ports

These classes can be found in ``local/clients/`` and ``local/site/``

client::icinga
^^^^^^^^^^^^^^

Sets up Icinga monitors on the host and connects them to the Icinga server.
Default monitors are ping and available disk space. 

client::jenkins
^^^^^^^^^^^^^^^

Sets up a Jenkins worker node on the host so Jenkins can connect over ssh to run jobs

client::proxy::connection
^^^^^^^^^^^^^^^^^^^^^^^^^

Sets up a url on the proxy server to point to a port on this host. Server
classes use this to expose their web interfaces

client::puppet
^^^^^^^^^^^^^^

Sets up a Puppet agent that will automatically configure the host

client::salt
^^^^^^^^^^^^

Sets up a salt minion that can run commands sent by the salt master

client::scratchdisk
^^^^^^^^^^^^^^^^^^^

Mounts the scratch SSD available on some NCI nodes to ``/scratch``


