## \file    modules/site/manifests/admin/pubkey.pp
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

define site::admin::pubkey (
  $user
) {
  $keystring = $name

  $elements = split($keystring,' ')

  $type    = $elements[0]
  $key     = $elements[1]
  $comment = regsubst($keystring,'^\S+\s+\S+\s+(.*)$','\1')

  ssh_authorized_key{"${user} ${comment}":
    ensure => present,
    key    => $key,
    type   => $type,
    user   => $user,
  }
}
