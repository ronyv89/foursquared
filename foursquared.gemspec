# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foursquared/version'

Gem::Specification.new do |gem|
  gem.name          = "foursquared"
  gem.version       = Foursquared::VERSION
  gem.authors       = ["Rony Varghese"]
  gem.email         = ["ronyv250289@gmail.com"]
  gem.description   = "Simple foursquare api client"
  gem.summary       = "Simple foursquare api client"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'httparty'
  gem.add_dependency 'oauth2'
end
