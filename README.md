# capistrano-scm-jenkins

[![Build Status](https://secure.travis-ci.org/lidaobing/capistrano-scm-jenkins.png?branch=master)](http://travis-ci.org/lidaobing/capistrano-scm-jenkins)

With this plugin, you can use jenkins build artifact as a repository, and
deploy your build artifact with capistrano.

## INSTALL

    gem install capistrano-scm-jenkins

## USAGE

a sample config/deploy.rb

```ruby
require 'capistrano-scm-jenkins'

set :application, "example"
set :repository,  "http://jenkins.example.com/job/example/"

set :scm, :jenkins

# uncomment following line if you want deploy unstable version
#   set :jenkins_use_unstable, true

# jenkins username and password
#   set :scm_username, ENV['JENKINS_USERNAME']
#   set :scm_password, ENV['JENKINS_PASSWORD']
# or use the netrc support for curl
#   set :jenkins_use_netrc, true
#
# if you use netrc, add the following line in your $HOME/.netrc
#   machine jenkins.example.com login USERNAME password secret
#
# bypass ssl verification
#   set :jenkins_insecure, true
#
# deploy from artifact subfolder. (ex: mv zipout/#{:jenkins_artifact_path} #{destination})
#   set :jenkins_artifact_path, 'archive'
#
# deploy a single file.
#   set :jenkins_artifact_file, 'webapp.war'
#

set :user, 'lidaobing'
set :use_sudo, false
set :deploy_to, "/home/#{user}/apps/#{application}"

role :web, "test.example.com"                          # Your HTTP server, Apache/etc
role :app, "test.example.com"                          # This may be the same as your `Web` server
role :db,  "test.example.com", :primary => true # This is where Rails migrations will run
```

for more information about capistrano, check https://github.com/capistrano/capistrano

### maven module

for the maven module, you should include the module name in your repository url. for example:

```ruby
set :repository,  "http://jenkins.example.com/job/example/com.example.helloworld$helloworld/"
```

## LICENSE

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
