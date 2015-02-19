# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-scm-jenkins/version'

Gem::Specification.new do |s|
  s.name          = 'capistrano-scm-jenkins'
  s.version       = CapistranoScmJenkins::VERSION
  s.authors       = ['LI Daobing', 'Jeff Byrnes']
  s.email         = ['lidaobing@gmail.com', 'jeff@evertrue.com']
  s.summary       = %q{Use Jenkins as a Capistrano 3.x SCM.}
  s.description   = %q{Capistrano 3.x plugin to deploy Jenkins artifacts.}
  s.homepage      = "https://github.com/lidaobing/#{s.name}"
  s.license       = 'MIT'

  s.rubyforge_project = 'capistrano-scm-jenkins'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '~> 3.2.1'

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
end
