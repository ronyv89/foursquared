require 'httmultiparty'
# Foursquared module
module Foursquared
  # The Client class
  class Client
    attr_accessor :access_token
    include HTTMultiParty
    include Users
    include Photos
    include Lists
    include Venues
    include Checkins
    include Badges
    include Events
    include Pages
    base_uri 'https://api.foursquare.com/v2/'
    format :json

    def initialize access_token
      @access_token = access_token
      self.class.default_params :oauth_token => access_token
    end

    # Do a 'get' request
    # @param [String] url the url to get
    # @param [Hash] options Additonal options to be passed
    def get url, options={}
      options.merge!({:v => Time.now.strftime("%Y%m%d")}) unless options[:v]
      response = self.class.get(url, {:query => options}).parsed_response
      if response["meta"]["code"] == 200
        return response
      else
        raise Foursquared::Error.new("meta")
      end
    end

    # Do a 'post' request
    # @param [String] url the url to post
    # @param [Hash] options Additonal options to be passed
    def post url, options={}
      options.merge!({:v => Time.now.strftime("%Y%m%d")}) unless options[:v]
      self.class.post(url, {:body => options}).parsed_response
    end

  end
end