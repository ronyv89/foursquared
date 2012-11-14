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
      self.class.default_params :oauth_token => access_token
    end

    def get url, options={}
      options.merge!({:v => Time.now.strftime("%Y%m%d")}) unless options[:v]
      self.class.get(url, {:query => options}).parsed_response
    end

    # def post url, options={}
    #   options.merge!({:v => Time.now.strftime("%Y%m%d")}) unless options[:v]
    #   self.class.post(url, options).parsed_response
    # end
  end
end