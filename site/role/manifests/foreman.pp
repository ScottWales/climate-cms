## \file    foreman.pp
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

# Foreman and Puppetmaster
class role::foreman(
  $url = $::fqdn,
) {
  $puppet_home = '/var/lib/puppet'
  $lower_url   = downcase($url)

  package {'centos-release-SCL': }

  class {'::foreman':
    foreman_url         => "https://${url}",
    servername          => $url,
    server_ssl_cert     => "${puppet_home}/ssl/certs/${lower_url}.pem",
    server_ssl_key      => "${puppet_home}/ssl/private_keys/${lower_url}.pem",
    websockets_ssl_cert => "${puppet_home}/ssl/certs/${lower_url}.pem",
    websockets_ssl_key  => "${puppet_home}/ssl/private_keys/${lower_url}.pem",
    configure_scl_repo  => false,
    require             => Package['centos-release-SCL'],
  }

  # TODO r10k & environments
}
