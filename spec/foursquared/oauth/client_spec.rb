require 'spec_helper'
require 'foursquared/oauth/client'
require 'pp'
require 'httparty'
describe Foursquared::OAuth::Client do
  before :each do
    @client = Foursquared::OAuth::Client.new("abc", "S2TJO3KFFXZSXS44WKVGWGKH204U455MI3P0JUV0ADTWRORZ","http://localhost")
  end

  describe "#authorize_url" do
    it "includes the client_id" do
      expect(@client.authorize_url).to include('client_id=abc')
    end

    it "includes the type" do
      expect(@client.authorize_url).to include('response_type=code')
    end

    it "includes the redirect_uri" do
      cb = 'http://localhost'
      expect(@client.authorize_url).to include("redirect_uri=#{Rack::Utils.escape(cb)}")
    end
  end
end