require 'httparty'

module Foursquared 
  
  class Client
    attr_accessor :access_token
    include HTTParty
    include Users
    base_uri 'https://api.foursquare.com/v2'
    format :json

    def initialize access_token
      @access_token = access_token
      self.class.default_params :oauth_token => access_token, :v => Time.now.strftime("%Y%m%d")
    end

    def get url, options={}
      self.class.get(url, options).parsed_response
    end

    def post url, options={}
      self.class.post(url, options).body
    end
  end
end