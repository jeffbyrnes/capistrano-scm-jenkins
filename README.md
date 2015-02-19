# Capistrano::Jenkins

[![Build Status](https://secure.travis-ci.org/lidaobing/capistrano-scm-jenkins.png?branch=master)](http://travis-ci.org/lidaobing/capistrano-scm-jenkins) [![Gem Version](https://badge.fury.io/rb/capistrano-scm-jenkins.png)](http://badge.fury.io/rb/capistrano-scm-jenkins) [![Dependency Status](https://gemnasium.com/lidaobing/capistrano-scm-jenkins.png)](https://gemnasium.com/lidaobing/capistrano-scm-jenkins)


Allows Capistrano to treat Jenkins as an SCM, deploying artifacts from a specified job.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-scm-jenkins'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install capistrano-scm-jenkins
```

## Usage

In your `Capfile`, you’ll need to `require 'capistrano-scm-jenkins`.

A sample `config/deploy.rb`:

```ruby
set :application, 'my-sweet-app'
set :repo_url, 'http://my.jenkins.install/job/my-sweet-app'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# Jenkins username & password
set :jenkins_user, 'user'
set :jenkins_pass, 'pass'

# Allow the deployment of unstable versions
# set :jenkins_use_unstable, true

# Deploy from artifact subfolder. (ex: mv zipout/#{:jenkins_artifact_path} #{destination})
# set :jenkins_artifact_path, 'archive'
#
# Deploy a single file.
# set :jenkins_artifact_file, 'my-api/target/webapp.war'
#
# Deploy a specific build number
# set(:jenkins_build_number, ENV['REVISION']) if ENV['REVISION']
#
# Bypass SSL verification
# set :jenkins_insecure, true
```

### maven module

For a Maven module, you should include the module name in the `:repo_url`:

```ruby
set :repo_url,  "http://jenkins.example.com/job/example/com.example.helloworld$helloworld/"
```

## Contributing

1. Fork it ( http://github.com/evertrue/capistrano-scm-jenkins/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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
