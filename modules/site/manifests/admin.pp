## \file    modules/site/manifests/admin.pp
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

# Create an admin user

define site::admin (
  $home    = "/home/${name}",
  $mail    = undef,
  $pubkeys = [],
) {

  user {$name:
    ensure         => present,
    home           => $home,
    managehome     => true,
    purge_ssh_keys => true,
  }

  site::admin::pubkey {$pubkeys:
    user => $name,
  }

  include sudo
  sudo::conf {$name:
    content => "${name} ALL=NOPASSWD:ALL",
  }

  if $mail {
    mailalias {$name:
      recipient => $mail,
    }
  }

}
