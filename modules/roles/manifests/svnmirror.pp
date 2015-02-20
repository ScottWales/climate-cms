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

# Set up a write-through subversion mirror
#
# Users at ${access_ip} are able to use this machine as their svn server instead
# of ${origin_ip}. Repository writes are passed-through to the master server,
# while reads come from this one for increased speed.
#
# By default the mirror will be updated every ${update_minutes} minutes,
# alternately the master repository can push updates in a post-receive hook.
#
# Repositories will be stored on the server under ${home} by default.
#
# Mirrors are configured using a hash, e.g. in Hiera:
#
# roles::svnmirror::mirrors:
#    UM:
#       origin: https://code.metoffice.gov.uk/svn/um_ext/UM
#    Admin:
#       origin: https://code.metoffice.gov.uk/svn/um_ext/Admin
#       url:    /admin
# Only the 'origin' parameter is mandatory, the rest will default to the values
# in roles::svnmirror
#
class roles::svnmirror (
  $home           = '/var/svn',
  $user           = 'svnsync',
  $group          = 'apache',
  $origin_ip      = '127.0.0.1',
  $access_ip      = '127.0.0.1',
  $update_minutes = 10,
  $vhost          = $::fqdn,
) {
  $mirrors        = hiera_hash('roles::svnmirror::mirrors',{})

  # Open firewall
  include ::site::firewall::http

  # Load Apache & modules
  include ::apache
  include ::apache::mod::dav_svn
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http

  # Get latest svn from Wandisco
  include ::wandisco

  # Process control
  include ::supervisord

  ensure_packages('subversion')
  ensure_packages('mod_dav_svn')

  # Redirect non-SSL connections to https
  apacheplus::vhost {"${vhost}-redirect":
    port     => 80,
    docroot  => '/var/www/null',
    rewrites =>[
      {
        comment      => 'SSL',
        rewrite_cond => ['%{HTTPS} !=on'],
        rewrite_rule => ['^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]'],
      }]
  }

  # Main vhost
  apacheplus::vhost {$vhost:
    ssl             => true,
    ssl_proxyengine => true,
    port            => 443,
    docroot         => '/var/www/null',
    proxy_pass      => [{
      'path'        => '/sync',
      'url'         => 'http://localhost:8080/',
    }],
    custom_fragment => '
      KeepAlive            On
      MaxKeepAliveRequests 1000
      SVNCacheTextDeltas   On
      SVNCacheFullTexts    On
      SVNCompressionLevel  5
      CustomLog logs/svn "%t %u %{SVN-ACTION}e" env=SVN-ACTION
      '
  }

  # Directory to store repositories in
  file {$home:
    ensure => directory,
  }

  # User owning the repository
  user {$user:
    gid            => $group,
    home           => $home,
    shell          => '/sbin/nologin',
    system         => true,
    purge_ssh_keys => true,
  }

  mailalias {$user:
    recipient => 'root',
  }

  # Sync user credential store
  file {"${home}/.subversion":
    ensure => directory,
    owner  => $user,
    mode   => '0700',
  }

  # Create mirrors listed in hiera
  create_resources('::roles::svnmirror::mirror', $mirrors)

  # Run a little webservice to listen for updates
  ensure_packages('python-cherrypy')

# apacheplus::location {'/sync':
#   vhost           => $vhost,
#   order           => 'Deny,Allow',
#   allow           => "from ${origin_ip} ${::ipaddress_eth0} localhost",
#   deny            => 'from all',
# }

  # Sync server
  file {'/usr/local/bin/svnsync-listener.py':
    source => 'puppet:///modules/roles/svnmirror/update-service.py',
    owner  => $user,
    group  => $group,
    notify => Class['supervisord::reload'],
  }

  supervisord::program {'svnsync-listener':
    command   => '/usr/bin/python /usr/local/bin/svnsync-listener.py',
    user      => $user,
  }
}
