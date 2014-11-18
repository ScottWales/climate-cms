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
  $url         = $::fqdn,
  $proxy_port  = 8443,
  $puppet_port = 8140,
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

  # Update apipie - http://projects.theforeman.org/issues/7063
  exec {'gem install apipie-bindings':
    command => 'scl enable ruby193 "gem install apipie-bindings"',
    unless  => 'scl enable ruby193 "gem list --local" | grep apipie-bindings',
    path    => ['/bin','/usr/bin'],
    before  => Class['::foreman_proxy'],
    require => Class['::foreman'],
  }

  class {'::foreman_proxy':
    foreman_base_url     => "https://${url}",
    trusted_hosts        => [$url],

    register_in_foreman  => true,
    registered_name      => $url,
    port                 => $proxy_port,
    registered_proxy_url => "https://${url}:${proxy_port}",
    puppet_url           => "https://${url}:${puppet_port}",

    dns                  => false,
    dhcp                 => false,
    tftp                 => false,

    ssl_cert             => "${puppet_home}/ssl/certs/${lower_url}.pem",
    ssl_key              => "${puppet_home}/ssl/private_keys/${lower_url}.pem",
    puppet_ssl_cert      => "${puppet_home}/ssl/certs/${lower_url}.pem",
    puppet_ssl_key       => "${puppet_home}/ssl/private_keys/${lower_url}.pem",
  }

  class {'::puppet':
    port                        => $puppet_port,

    server                      => true,
    server_ca                   => false,
    server_certname             => $url,
    server_foreman_url          => "https://${url}",
    server_port                 => $puppet_port,
    server_foreman_ssl_cert     => "${puppet_home}/ssl/certs/${lower_url}.pem",
    server_foreman_ssl_key      => "${puppet_home}/ssl/private_keys/${lower_url}.pem",
    server_storeconfigs_backend => 'puppetdb'
  }

  class {'::puppetdb':
    manage_dbserver => false,
  }
  class {'::puppetdb::master::config':
  }

  # TODO r10k & environments
}
