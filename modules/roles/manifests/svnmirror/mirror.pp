## \file    modules/roles/manifests/svnmirror/mirror.pp
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

define roles::svnmirror::mirror (
  $origin,
  $origin_user    = undef,
  $origin_secret  = undef,
  $repo           = $name,
  $url            = "/${name}",
  $origin_ip      = $::roles::svnmirror::origin_ip,
  $access_ip      = $::roles::svnmirror::access_ip,
  $update_minutes = $::roles::svnmirror::update_minutes,
) {

  # Things we need from the server class
  $vhost          = $::roles::svnmirror::vhost
  $home           = $::roles::svnmirror::home
  $user           = $::roles::svnmirror::user
  $group          = $::roles::svnmirror::group

  # Filesystem location for the repo
  $path = "${home}/${repo}"

  # Cache credentials
  exec {"cache-credentials ${origin}":
    path    => ['/bin','/usr/bin'],
    command => "svn info --config-option servers:global:store-passwords=yes --config-option servers:global:store-plaintext-passwords=yes --username ${origin_user} --password ${origin_secret} ${origin}",
    unless  => "svn info ${origin}",
    user    => $user,
    require => File["${home}/.subversion"],
  }

  file {$path:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  # Create the repository
  exec {"svnadmin create ${path}":
    path    => ['/bin','/usr/bin'],
    user    => $user,
    group   => $group,
    creates => "${path}/format",
    require => File[$path],
  }

  # Create a hook
  file {"${path}/hooks/pre-revprop-change":
    ensure  => present,
    content => "#!/bin/sh\nexit 0\n",
    mode    => '0555',
    require => Exec["svnadmin create ${path}"],
  }

  # Initialise sync
  exec {"svnsync init ${path}":
    command   => "svnsync init file://${path} ${origin}",
    path      => ['/bin','/usr/bin'],
    user      => $user,
    group     => $group,
    unless    => "grep '^${origin}$' ${path}/db/revprops/0/0",
    logoutput => true,
    require   => [
      Exec["svnadmin create ${path}", "cache-credentials ${origin}"],
      File["${path}/hooks/pre-revprop-change"],
    ],
  }

  # Do regular pulls
  cron {"svnsync sync ${path}":
    command   => "/usr/bin/svnsync sync --non-interactive file://${path}",
    user      => $user,
    minute    => "*/${update_minutes}",
    require   => Exec["svnsync init ${path}"],
  }

# # The mirror is accessed from here
# # Also allow access from the local machine's IP address for testing
# apacheplus::location {$url:
#   vhost           => $vhost,
#   order           => 'Deny,Allow',
#   allow           => "from ${access_ip} ${::ipaddress_eth0} localhost",
#   deny            => 'from all',
#   custom_fragment => "
#     DAV                  svn
#     SVNPath              ${path}
#     SVNMasterURI         ${origin}
#   "
# }

# # The origin site can push updates to here
# apacheplus::location {"${url}-sync":
#   vhost           => $vhost,
#   order           => 'Deny,Allow',
#   allow           => "from ${origin_ip} ${::ipaddress_eth0} localhost",
#   deny            => 'from all',
#   custom_fragment => "
#     DAV          svn
#     SVNPath      ${path}
#   "
# }

}
