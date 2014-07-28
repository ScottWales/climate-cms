## \file    modules/site/manifests/init.pp
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

class site (
  $secure = false,
  $admins = {},
) {
  if ! $secure {
    warning('Not using secure passwords or certificates')
  }

  file {'/usr/sbin/provision':
    source => 'puppet:///modules/site/provision.sh',
    mode   => '0500',
  }

  # Don't require a tty for sudoers
  sudo::conf {'requiretty':
    priority => 10,
    content  => 'Defaults !requiretty',
  }

  create_resources('site::admin',$admins)

  # Allow SSH
  firewall { '022 accept ssh':
    proto  => 'tcp',
    port   => '22',
    action => 'accept',
  }

}
