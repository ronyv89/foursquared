require 'spec_helper'
require 'foursquared/response/user'
require 'foursquared/response/photo'
require 'foursquared/client'
require 'pp'
describe Foursquared::Response::Photo do
  
  let(:photo) do
    YAML.load(%{
      meta:
        code: 200
      response:
        photo:
          id: "4d0fb8162d39a340637dc42b"
          createdAt: 1292875798
          source:
            name: "foursquare for iPhone"
            url: "https://foursquare.com/download/#/iphone"
          prefix: "https://irs0.4sqi.net/img/general/"
          suffix: "/UYU54GYOCURPAUYXH5V2U3EOM4DCX4VZPT3YOMN43H555KU2.jpg"
          width: 540
          height: 720
          user:
            id: "2102"
            firstName: "Kushal"
            lastName: "D."
            photo:
              prefix: "https://irs1.4sqi.net/img/user/"
              suffix: "/2102_1242573242.jpg"
          visibility: "public"
      }
    )
  end

  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/photos/12345?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => photo.to_json, :headers => {})
    @test_photo = foursquared_test_client.photo(12345)
  end
  it "should return the photo id" do
    @test_photo.id.should == "4d0fb8162d39a340637dc42b"
  end

  it "should return photo url's suffix" do
    #p test_photo
    #subject.prefix.should == "https://irs0.4sqi.net/img/general/"
  end

end