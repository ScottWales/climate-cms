#!/usr/bin/env python
"""
file:   modules/roles/files/svnmirror/update-service.py
author: Scott Wales <scott.wales@unimelb.edu.au>

Simple Python webservice that updates SVN when it gets a POST

Most likely you want to secure this behind a reverse proxy so it can only be
used by the master server.

---
Copyright 2014 ARC Centre of Excellence for Climate Systems Science

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import cherrypy
import subprocess

class SvnsyncWebService(object):
    exposed = True

    def POST(self):
        data = cherrypy.request.body
        cherrypy.log("Running sync with %s"%data)
        subprocess.Popen(["svnsync","--non-interactive","sync","file:///var/svn/um_ext"])


if __name__ == '__main__':
    conf = {
            '/': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                }
            }
    cherrypy.quickstart(SvnsyncWebService(),'/',conf)
