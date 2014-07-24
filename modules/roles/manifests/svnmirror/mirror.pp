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

class roles::svnmirror::mirror (
  $origin,
  $url            = "/${name}",
  $vhost          = $::roles::svnmirror::vhost,
  $origin_ip      = $::roles::svnmirror::origin_ip,
  $access_ip      = $::roles::svnmirror::access_ip,
  $home           = $::roles::svnmirror::home,
  $user           = $::roles::svnmirror::user,
  $group          = $::roles::svnmirror::group,
  $update_minutes = $::roles::svnmirror::update_minutes,
) {
  $repo = $name  
  $path = "${home}/${repo}"

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

  # Initialise sync
  exec {"svnsync init ${path}":
    command => "svnsync init file://${path} ${origin}",
    path    => ['/bin','/usr/bin'],
    user    => $user,
    group   => $group,
    onlyif  => "svn info file://${path} | grep '^Revision: 0$'",
    require => Exec["svnadmin create ${path}"],
  }

  # Do regular pulls
  cron {"svnsync sync ${path}":
    command => "/usr/bin/svnsync ${path} ${origin}",
    user    => $user,
    minute  => "*/${update_minutes}",
    require => Exec["svnsync init ${path}"],
  }

  # The mirror is accessed from here
  apachesite::location {$url:
    vhost           => $vhost,
    order           => "Deny,Allow",
    allow           => "from ${access_ip}",
    deny            => "from all",
    custom_fragment => "
      DAV          svn
      SVNPath      ${path}
      SVNMasterURI ${origin}
    "
  }

  # The origin site can push updates to here
  apachesite::location {"${url}-sync":
    vhost           => $vhost,
    order           => "Deny,Allow",
    allow           => "from ${origin_ip}",
    deny            => "from all",
    custom_fragment => "
      DAV          svn
      SVNPath      ${path}
    "
  }

}
