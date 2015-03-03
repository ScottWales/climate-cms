## \file    local/roles/manifests/proxy.pp
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

class roles::proxy (
  $vhost = $::fqdn,
) {
  include site::firewall::http

  class { 'apache':
  }

  # Ensure HTTPS is used
  apache::vhost { "${vhost}_redirect":
    port            => '80',
    docroot         => '/var/www/null',
    redirect_source => '/',
    redirect_dest   => "https://${vhost}/",
    redirect_status => 'temp',
  }

  apache::vhost { $vhost:
    port    => '443',
    docroot => '/var/www/html',
    ssl     => true,
  }
}
