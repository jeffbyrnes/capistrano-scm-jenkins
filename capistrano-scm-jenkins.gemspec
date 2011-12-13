# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-scm-jenkins/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-scm-jenkins"
  s.version     = Capistrano::Scm::Jenkins::VERSION
  s.authors     = ["LI Daobing"]
  s.email       = ["lidaobing@gmail.com"]
  s.homepage    = "https://github.com/lidaobing/capistrano-scm-jenkins"
  s.summary     = %q{use jenkins as a capistrano scm}
  s.description = %q{
With this plugin, you can use jenkins build artifact as a repository, and
deploy your build artifact with capistrano.
  }

  s.rubyforge_project = "capistrano-scm-jenkins"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "capistrano"
  s.add_runtime_dependency "net-netrc"
  s.add_development_dependency "rspec"
end
