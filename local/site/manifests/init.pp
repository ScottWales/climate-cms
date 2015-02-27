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

# Generic configuration stuff
class site (
  $hostname = $::hostname,
  $domain   = $::domain,
  $secure   = false,
  $admins   = {},
) {
  if ! $secure {
    warning('Not using secure passwords or certificates')
  }
  include ::ntp

  service { 'network': }

  host { "${hostname}.${domain}":
    host_aliases => $hostname,
    ip           => $::ipaddress_eth0,
    notify       => Service['network'],
  }
  file { '/etc/hostname':
    ensure  => file,
    content => "${hostname}\n",
    notify  => Service['network'],
  }

  # Don't require a tty for sudoers
  sudo::conf {'requiretty':
    priority => 10,
    content  => 'Defaults !requiretty',
  }

  create_resources('site::admin',$admins)

  # Send root mail to admins
  $admin_names = keys($admins)
  mailalias {'root':
    recipient => $admin_names,
  }

  # Allow SSH
  firewall { '022 accept ssh':
    proto  => 'tcp',
    port   => '22',
    action => 'accept',
  }

  # Updates
  class {'yum_cron':
    check_only => 'no',
  }

  include site::puppet
}
