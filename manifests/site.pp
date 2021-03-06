## \file    manifests/site.pp
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

node default {

  # Always include ::site
  include ::site

  # Include classes listed in Hiera
  hiera_include('classes',[])

  # Silence deprecation warning
  Package {allow_virtual => false}

  # Firewall defaults
  Firewall {
    require => Class['::site::firewall::pre'],
    before  => Class['::site::firewall::post'],
  }
  include ::site::firewall::pre
  include ::site::firewall::post

  # Ensure Pip is available before we install packages with it
  ensure_packages('python-pip')
  Package['python-pip'] -> Package<| provider == pip |>
}
