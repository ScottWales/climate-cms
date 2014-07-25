## \file    modules/roles/manifests/svnmirror.pp
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
  $user           = 'apache',
  $group          = 'apache',
  $origin_ip      = '127.0.0.1',
  $access_ip      = '127.0.0.1',
  $update_minutes = 5,
  $mirrors        = {},
  $vhost          = $::fqdn,
) {
  include ::apache
  include ::apache::mod::dav_svn

  include ::wandisco

  ensure_packages('subversion')

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
  apacheplus::vhost {$vhost:
    ssl     => true,
    port    => 443,
    docroot => '/var/www/null',
  }

  Roles::Svnmirror::Mirror {
    vhost => $vhost,
  }

  create_resources('::roles::svnmirror::mirror', $mirrors)
}
