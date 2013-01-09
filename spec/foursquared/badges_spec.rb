require 'spec_helper'
require 'foursquared/badges'

describe Foursquared::Badges do

  let(:user_badges) do
    YAML.load(%{
      meta:
        code: 200
      response:
        sets:
          groups:
            - type: "all"
              name: "All Badges"
              image:
                prefix: "https://foursquare.com/img/badge/"
                sizes:
                - 24
                - 32
              name: "/allbadges.png"
              items:
              - "508b859de4b01167eaad0476"
              - "5066d689e4b0ca8b1f1c1804"
        badges:
          4f7a7d3ae4b02f1b2c869efb:
            id: "4f7a7d3ae4b02f1b2c869efb"
            badgeId: "4c4f08667a0803bbaa202ab7"
        defaultSetType: "foursquare"
      }
    )
  end

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

  subject { foursquared_test_client }

  describe "#badge" do
    it "should return the badge with the given badge ID" do
      stub_request(:get, "https://api.foursquare.com/v2/badges/4f7a7d3ae4b02f1b2c869efb?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => badge.to_json, :headers => {})
      subject.badge("4f7a7d3ae4b02f1b2c869efb").should be_a(Foursquared::Response::Badge)
    end
  end
end