#!/bin/bash
## \file    scripts/boot.sh
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

image='centos-6.6-20141116'
flavor='m1.small'
branch='master'

envpath='/etc/puppet/environments'

# Boot a cloud instance then provision with Puppet
# Here we're just installing basic dependencies & checking out the repository,
# the provision script will do the rest of the work.
nova boot "subversion-mirror" \
    --image="$image" \
    --flavor="$flavor" \
    --security-groups "ssh,http" \
    --poll \
    --user-data <( cat <<EOF
#cloud-config
disable_root:     true
manage_etc_hosts: localhost

runcmd:
    - rpm -i http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    - yum -y install git puppet rubygems yum-versionlock
    - yum versionlock puppet
    - gem install --no-ri --no-rdoc librarian-puppet -v '<1.1.0'
    - git clone -b ${branch} https://github.com/ScottWales/svnmirror ${envpath}/production
    - ln -s /etc/puppet/{environments/production/,}hiera.yaml
    - bash ${envpath}/production/modules/site/files/provision.sh

EOF
)

