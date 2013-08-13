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

  describe '#get_access_token' do
    it "should return the access code" do
      stub_request(:post, "https://foursquare.com/oauth2/access_token").with(:body => {"client_id"=>"abc", "client_secret"=>"S2TJO3KFFXZSXS44WKVGWGKH204U455MI3P0JUV0ADTWRORZ", "code"=>"hello", "grant_type"=>"authorization_code", "redirect_uri"=>"http://localhost"},:headers => {'Accept'=>'*/*', 'User-Agent'=>'Faraday v0.8.8'}).to_return(:status => 200, :body => {:access_token => "TestToken"}.to_json, :headers => {"content-type"          =>  "application/json"})
      @client.get_access_token("hello").should == "TestToken"
    end
  end
end