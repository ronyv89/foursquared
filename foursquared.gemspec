# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foursquared/version'

Gem::Specification.new do |gem|
  gem.name          = "foursquared"
  gem.platform      = Gem::Platform::RUBY
  gem.version       = Foursquared::VERSION
  gem.authors       = ["Rony Varghese"]
  gem.email         = ["ronyv250289@gmail.com"]
  gem.description   = "Simple foursquare api client"
  gem.summary       = "Simple foursquare api client"
  gem.homepage      = "https://github.com/ronyv89/foursquared"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'httmultiparty'
  gem.add_dependency 'oauth2'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "metric_abc"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "ci_reporter"
  gem.add_development_dependency "simplecov-rcov"
  gem.add_development_dependency "rdiscount"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "rspec_multi_matchers"
end
