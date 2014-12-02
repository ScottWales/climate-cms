#!/bin/bash
## \file    bootstrap.sh
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#
#  Copyright 2014 ARC Centre of Excellence for Climate Systems Science
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# Install Puppet
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y puppet
gem install r10k

# Configure environments
echo /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
    puppet: 'https://github.com/ScottWales/climate-cms
    basedir: '/etc/puppet/environments'
EOF

echo /etc/hiera.yaml << EOF
---
:backends:
    - yaml
:hierarchy:
    - nodes/%{fqdn}
    - common
:yaml:
    :datadir: /etc/puppet/environments/%{environment}/hiera
EOF

# Provision the server
r10k deploy environment -p
puppet agent -t --environment test
