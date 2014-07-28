## \file    modules/apacheplus/manifests/location.pp
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

define apacheplus::location (
  $vhost,
  $path            = $name,
  $order           = '20',
  $provider        = 'location',
  $order           = 'Allow,Deny',
  $allow           = 'from all',
  $deny            = 'from none',
  $custom_fragment = undef,
) {
  if ! defined(Class['apache']) {
    fail('You must include the apache class first')
  }
  $filename = regsubst($vhost, ' ', '_', 'G')
  $config = "${::apache::vhost_dir}/${filename}.locations"


  $_directories = {
    path            => $path,
    provider        => $provider,
    order           => $order,
    allow           => $allow,
    deny            => $deny,
    custom_fragment => $custom_fragment,
  }

  concat::fragment {"Location ${name}":
    target  => $config,
    content => template('apache/vhost/_directories.erb'),
    order   => $order,
  }
}

