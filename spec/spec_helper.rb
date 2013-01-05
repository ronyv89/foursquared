require "simplecov"
require "simplecov-rcov"
require 'foursquared'
require 'webmock/rspec'
require 'rspec_multi_matchers'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter "vendor"
  add_filter "spec"
end if ENV["COVERAGE"]

def foursquared_test_client
  Foursquared::Client.new("TestToken")
end

class Array
  def unique?
    length == uniq.length
  end

  def method_missing name
    if name.to_s =~ /^empty_or_array_of_(.+)s\?$/
      empty? or collect{|item| item.is_a?(Foursquared::Response.const_get($1.capitalize))}.all?
    end
  end
end