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

  before(:each) do
    stub_request(:get, "https://api.foursquare.com/v2/users/self/badges?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => user_badges.to_json, :headers => {})
    stub_request(:get, "https://api.foursquare.com/v2/badges/4f7a7d3ae4b02f1b2c869efb?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => badge.to_json, :headers => {})
    @user_badges = subject.user_badges("self")
  end
  describe "#user_badges" do
    describe "sets" do
      it "should give the sets of badge types" do
        @user_badges["sets"]["groups"].should each { |group|
          group.should be_a(Foursquared::Response::BadgeGroup)
        }
      end
    end
    describe "badges" do
      it "should give the badges' details" do
        @user_badges["badges"].keys.should each {|badge_id|
          @user_badges["badges"][badge_id].should be_a(Foursquared::Response::Badge)
        }
      end
    end
  end
end