## \file    manifests/site.pp
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

# Generic server configs
node default {

  # Puppet service
  include site::puppet

  # Yum updates
  include site::updates

  # Local hostnames
  include site::hosts

  # Setup firewall
  resources {'firewall':
    purge => true,
  }
  Firewall {
    require => Class[site::firewall::defaults],
    before  => Class[site::firewall::dropall],
  }
  include site::firewall::defaults
  include site::firewall::dropall

  Package {
    allow_virtual => true,
  }
}
