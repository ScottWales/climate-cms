## \file    site/manifests/admin.pp
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

define site::admin (
  $keys,
  $home   = "/users/${name}",
  $ensure = 'present',
) {

  user {$name:
    ensure         => $ensure,
    groups         => 'root',
    managehome     => true,
    purge_ssh_keys => true,
    shell          => '/bin/bash',
  }

  sudo::conf {$name:
    content => "${name} ALL=(ALL) NOPASSWD: ALL",
  }

  ensure_hash($keys)
  create_resources('site::adminuser::key', $keys)

}
