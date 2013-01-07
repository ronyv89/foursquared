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

    def initialize credentials={}
      
      if credentials[:access_token]
        self.class.default_params :oauth_token => credentials[:access_token]
      elsif credentials[:client_id] and credentials[:client_secret]
        self.class.default_params :client_id => credentials[:client_id]
        self.class.default_params :client_id => credentials[:client_id]
      else
        raise "Must provide access_token or client_id and client_secret"
      end
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
        raise Foursquared::Error.new(response["meta"])
      end
    end

    # Do a 'post' request
    # @param [String] url the url to post
    # @param [Hash] options Additonal options to be passed
    def post url, options={}
      options.merge!({:v => Time.now.strftime("%Y%m%d")}) unless options[:v]
      response = self.class.post(url, {:body => options}).parsed_response
      if response["meta"]["code"] == 200
        return response
      else
        raise Foursquared::Error.new(response["meta"])
      end
    end

  end
end