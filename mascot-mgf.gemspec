# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mascot/mgf/version"

Gem::Specification.new do |s|
  s.name        = "mascot-mgf"
  s.version     = Mascot::MGF::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Angel Pizarro"]
  s.email       = ["delagoya@gmail.com"]
  s.homepage    = "https://github.com/delagoya/mascot-mgf"
  s.summary     = %q{A parser for Mascot Generic Format (MGF) files}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
