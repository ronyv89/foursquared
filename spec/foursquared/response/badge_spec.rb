require 'spec_helper'
require 'foursquared/response/badge'

describe Foursquared::Response::Badge do

  let(:badge) do
    YAML.load(%{
        meta:
          code: 200
        response:
          badge:
            id: "4f7a7d3ae4b02f1b2c869efb"
            badgeId: "4c4f08667a0803bbaa202ab7"
            name: "Newbie"
            unlockMessage: "You unlocked the Newbie badge!"
            description: "Your first check-in!"
            badgeText: "Your first check-in!"
            image:
              prefix: "https://playfoursquare.s3.amazonaws.com/badge/"
              sizes:
              - 57
                114
              name: "/newbie.png"
            unlocks:
            - checkins:
              - id: "4f7a7d3ae4b02f1b2c869eef"
      }
    )
  end
  subject {foursquared_test_client.badge("4f7a7d3ae4b02f1b2c869efb")}

  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/badges/4f7a7d3ae4b02f1b2c869efb?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => badge.to_json, :headers => {})
  end

  it "should return the badge's id" do
    subject.id.should == "4f7a7d3ae4b02f1b2c869efb"
  end

end