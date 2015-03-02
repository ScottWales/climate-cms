## \file    local/site/manifests/network.pp
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

# Manages network & hosts file
class site::network (
) {

  resources {'host':
    purge => true,
  }

  service {'network':
    ensure => running,
  }

  Host {
    notify => Service['network'],
  }

  file { '/etc/hostname':
    ensure  => file,
    content => "${site::hostname}\n",
    notify  => Service['network'],
  }

  host {'localhost':
    ip           => '127.0.0.1',
    host_aliases => [
      'localhost.localdomain',
      'localhost4',
      'localhost4.localdomain4',],
  }

  host {'localhost6':
    ip           => '::1',
    host_aliases => [
      'localhost6.localdomain6',
      'localhost',
      'localhost.localdomain',],
  }

  @@host {"${site::hostname}.${site::domain}":
    ip           => $::ipaddress_eth0,
    host_aliases => $site::hostname,
  }

  # Collect all hosts
  Host <<||>>
}
