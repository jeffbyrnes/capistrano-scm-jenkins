# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'capistrano-scm-jenkins'
  s.version       = '0.5.3'
  s.authors       = ['Li Daobing', 'Jeff Byrnes']
  s.email         = ['lidaobing@gmail.com', 'thejeffbyrnes@gmail.com']
  s.summary       = 'Use Jenkins as a Capistrano 3.x SCM.'
  s.description   = 'Capistrano 3.x plugin to deploy Jenkins artifacts.'
  s.homepage      = "https://github.com/jeffbyrnes/#{s.name}"
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '~> 3.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
