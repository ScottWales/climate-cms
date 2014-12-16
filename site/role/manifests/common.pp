## \file    site/role/manifests/common.pp
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

class role::common {

  # Puppet service
  include role::puppet

  # Local hostnames
  include site::hosts

  # Server security
  include site::security

  # Allow ssh access
  include site::firewall::ssh

  # Admin user
  user {'swales':
    ensure     => present,
    managehome => true,
  }
  ssh_authorized_key {'swales-admin':
    user => 'swales',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC66UV5uI+2k1WtgefX33ugqS+6trtMnD3bzkQZm6hCRe1Zjt8cABiBx06yNRECjTYX1Crfh8sOzwFTH6NlhF0oEg4iSv3WWutAOROONoKKsMFr0m3e31dUVwf0BrpuCt0HqJ/Z+lKgzB6Cz1vPTjfMjn2ut0So3u3zTpZjIYputEweAjF/FQEzlNjx9FmMcOMC0XrEDYdMrKq/9dwmXHT/4W6w9LC4sBsXVB+Cs2xcmxoD+K5j1PlUUIM9ffJxU5uGF90eR2GH3ZM2+R34uE/8LQutE3ctRDM+sHOrhyMFo+4Hqc0QtyWkBF/IGa5tfd0MNxKKuh/1l6SHQW2gLbaL',
  }
  mailalias {'root':
    recipient => 'scott.wales@unimelb.edu.au',
  }

}
