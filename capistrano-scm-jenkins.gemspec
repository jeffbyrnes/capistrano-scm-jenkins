# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-scm-jenkins/version'

Gem::Specification.new do |s|
  s.name          = 'capistrano-scm-jenkins'
  s.version       = Capistrano::JenkinsScm::VERSION
  s.authors       = ['LI Daobing', 'Jeff Byrnes']
  s.email         = ['lidaobing@gmail.com', 'jeff@evertrue.com']
  s.summary       = %q{use jenkins as a capistrano scm}
  s.description   = %q{
With this plugin, you can use jenkins build artifact as a repository, and
deploy your build artifact with capistrano.
  }
  s.homepage      = "https://github.com/lidaobing/#{s.name}"
  s.license       = 'MIT'

  s.rubyforge_project = 'capistrano-scm-jenkins'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency     'capistrano', '~> 2.0'
  s.add_runtime_dependency     'net-netrc'
  s.add_runtime_dependency     'rubyzip', '~> 0.0'

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
