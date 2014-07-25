## \file    modules/wandisco/manifests/init.pp
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

# Sets up Wandisco Yum repository
class wandisco {
  $gpgkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-WANdisco'

  file {$gpgkey:
    ensure => present,
    source => 'puppet:///modules/wandisco/RPM-GPG-KEY-WANdisco',
  }

  if $::osfamily == 'redhat' {
    yumrepo {'wandisco':
      ensure   => present,
      baseurl  => 'http://opensource.wandisco.com/rhel/6/svn-1.8/RPMS/',
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "file://${gpgkey}",
      require  => File[$gpgkey],
      before   => Package['subversion'],
    }
  } else {
    fail("${::osfamily} is unsupported")
  }
}
