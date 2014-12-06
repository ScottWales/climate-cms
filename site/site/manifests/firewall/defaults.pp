## \file    firewall/defaults.pp
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

# Default firewall rules
class site::firewall::defaults {

  Firewall {
    require => undef,
  }

  firewall {'000 accept icmp':
    proto  => 'icmp',
    action => 'accept',
  }

  firewall {'001 accept lo':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall {'002 accept established':
    proto  => 'all',
    state  => ['RELATED','ESTABLISHED'],
    action => 'accept',
  }

  firewall {'000 accept icmp ip6':
    proto    => 'icmp',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall {'001 accept lo ip6':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall {'002 accept established ip6':
    proto    => 'all',
    state    => ['RELATED','ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
