require "simplecov"
require "simplecov-rcov"
require 'foursquared'
require 'webmock/rspec'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter "vendor"
  add_filter "spec"
end if ENV["COVERAGE"]

def foursquared_test_client
  Foursquared::Client.new("TestUser")
end