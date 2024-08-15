# -*- encoding: utf-8 -*-
require File.expand_path('../lib/geom/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adrian Smith"]
  gem.email         = ["adrianlloydsmith@gmail.com"]
  gem.description   = "A 3D geometry library that includes Point, Vector, Line, Plane, Coordinate System and Transformation objects"
  gem.summary       = "A 3D geometry library"
  gem.homepage      = "https://github.com/AdrianSmith/geom"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "geom"
  gem.require_paths = ["lib"]
  gem.version       = Geom::VERSION

  gem.required_ruby_version = "~> 3.0"

  gem.add_development_dependency "bundler", "~> 2.5"
  gem.add_development_dependency "rake", "~> 13.0"
end
