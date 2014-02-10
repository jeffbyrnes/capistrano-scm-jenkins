# Capistrano::JenkinsScm

[![Build Status](https://secure.travis-ci.org/lidaobing/capistrano-scm-jenkins.png?branch=master)](http://travis-ci.org/lidaobing/capistrano-scm-jenkins) [![Gem Version](https://badge.fury.io/rb/capistrano-scm-jenkins.png)](http://badge.fury.io/rb/capistrano-scm-jenkins)

Allows Capistrano to treat Jenkins as an SCM, deploying artifacts from a specified job.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-jenkins_scm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-jenkins_scm

## Usage

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
# filter the scm log with prefix when deploy:pending
#   set :jenkins_scm_log_prefix, 'project_name/'

set :user, 'username'
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

## Contributing

1. Fork it ( http://github.com/evertrue/capistrano-jenkins_scm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
