#!/bin/bash
## \file    userdata.sh
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#
#  Copyright 2015 ARC Centre of Excellence for Climate Systems Science
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

hostname=${1:-'puppet'}
environment='puppetmaster'

image='centos-6.6-20150129'
flavor='m1.small'

if [ "$hostname" == 'puppet' ]; then
    # This is the Puppetmaster, we'll need to set that up
    master_ip=127.0.0.1
    setup_master="
    yum install -y -q puppetserver rubygems git

    # Install r10k
    gem install r10k --no-ri --no-rdoc
    cat > /etc/r10k.yaml << EOF
    :cachedir: '/var/cache/r10k'
    :sources:
        :coecms:
            remote:  'https://github.com/ScottWales/climate-cms'
            basedir: '/etc/puppet/environments'
    EOF

    # Deploy environments
    r10k deploy environment --puppetfile --verbose
    ln -s /etc/puppet/environments/${environment}/hiera.yaml /etc/puppet/hiera.yaml

    # Start server
    sed -e '/JAVA_ARGS/s/2g/512m/g' -i /etc/sysconfig/puppetserver
    service puppetserver restart
    puppet cert list --all
    "
else
    # Get the master's IP
    master_ip=10.0.0.0
fi

userdata="#!/bin/bash
echo
set -xeu

# Puppet master IP
echo '${master_ip} puppet' >> /etc/hosts

# Puppet packages
rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum clean all
yum makecache -q

# Setup Puppet
yum install -y -q puppet
cat > /etc/puppet/puppet.conf << EOF
[main]
    certname = ${hostname}
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = \\\$vardir/ssl
    environmentpath = \\\$confdir/environments
[agent]
    classfile = \\\$vardir/classes.txt
    localconfig = \\\$vardir/localconfig
    environment = ${environment}
EOF

${setup_master}

service puppet restart
"

nova boot "$hostname" \
    --image "$image" \
    --flavor "$flavor" \
    --user-data <(echo "$userdata") \
    --key-name walesnix \
    --security-groups ssh \
    --poll
