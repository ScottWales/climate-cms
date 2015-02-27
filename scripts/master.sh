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

master_ip=127.0.0.1
image='centos-6.6-20150129'
flavor='m1.small'
environment='puppetmaster'
hostname='test'

userdata="#!/bin/bash
echo
set -xeu

# Install Puppet Master
echo '${master_ip} puppet' >> /etc/hosts
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
EOF

# Install server
yum install -y -q puppetserver
sed -e '/JAVA_ARGS/s/2g/512m/g' -i /etc/sysconfig/puppetserver
service puppetserver restart
puppet cert list --all

# Install r10k
yum install -y -q rubygems git
gem install r10k --no-ri --no-rdoc
cat > /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
    :coecms:
        remote:  'https://github.com/ScottWales/climate-cms'
        basedir: '/etc/puppet/environments'
EOF
ln -s /etc/puppet/environments/${environment}/hiera.yaml /etc/puppet/hiera.yaml

# Deploy
r10k deploy environment -p -v
puppet agent --color=false --test --environment ${environment} || true
"

nova boot "$hostname" \
    --image "$image" \
    --flavor "$flavor" \
    --user-data <(echo "$userdata") \
    --key-name walesnix \
    --security-groups ssh \
    --poll
