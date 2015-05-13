Admin Tasks
===========

Add a new admin
---------------

Edit the file ``hireadata/admins.yaml``, adding the new admin's username and
public ssh key. Commit the changes and :ref:`updatePuppet`.

SSH to a Server
---------------

Not all servers in the cloud have public IPs. To connect to an arbitrary server
go through the gateway first::

    ssh -A climate-cms.org
    ssh monitor

.. _updatePuppet:

Update Puppet
-------------

First connect to the Puppet server::

    ssh -A climate-cms.org
    ssh puppet-2

Shut down any running Puppet agent instances::

    sudo salt '*' service.stop puppet

Pull updates from Github and update modules::

    sudo r10k deploy environment --puppetfile

Do a dry run to make sure changes are doing what you expect::

    sudo salt '*' puppet.noop agent test

Finally apply the changes and restart the Puppet agents (``test`` here
means print changes and don't run in the background)::

    sudo salt '*' puppet.run agent test
    sudo salt '*' service.start puppet

