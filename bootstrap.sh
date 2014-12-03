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

set -x

# Install Puppet
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y puppet git
#gem install r10k --no-ri --no-rdoc --verbose

# Configure environments
cat > /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
    :puppet: 
        remote: 'https://github.com/ScottWales/climate-cms'
        basedir: '/etc/puppet/environments'
EOF

cat > /etc/hiera.yaml << EOF
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
r10k deploy environment --verbose --puppetfile
environment=/etc/puppet/environments/testing
puppet apply $environment/manifests/site.pp --modulepath $environment/site:$environment/modules
