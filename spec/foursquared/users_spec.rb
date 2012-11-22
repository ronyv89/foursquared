# require 'foursquared/users'
# require 'foursquared/lists'
# require 'foursquared/venues'
# require 'foursquared/photos'
# require 'foursquared/client'
require 'spec_helper'
require 'pp'
describe Foursquared::Users do
  let(:me) do
    YAML.load(%{
      meta:
        code: 200
      notifications:
        type: "notificationTray"
        item:
          unreadCount: 0
      response:
        user:
          id: "12345678"
          firstName: "Rony"
          lastName: "Varghese"
          relationship: "self"
          photo:
            prefix: "https://irs1.4sqi.net/img/user/"
            suffix: "/HE1OX3T3S3HN5OI4.jpg"
          friends:
            count: 61
            groups:
            - type: "friends"
              name: "Mutual friends"
              count: 0
              items: []
            - type: "others"
              name: "Other friends"
              count: 61
              items:
              - id: "40430295"
                firstName: "Benjamin"
                lastName: "Peter"
                relationship: "friend"
                photo:
                  prefix: "https://irs0.4sqi.net/img/user/"
                  suffix: "/4GBCUQTWEX4H4KNZ.jpg"
                  tips:
                    count: 0
                  lists:
                    groups:
                    - type: "created"
                      count: 1
                      items: []
                    gender: "male"
                    homeCity: "Maharashtra"
                    bio: ""
                    contact:
                      email: "blahblah@blah.com"
                      facebook: "435463435"
                }
    )
  end

  let(:leaderboard) do
    YAML.load(%{
        meta:
          code: 200
        response:
          leaderboard:
            count: 3
            items:
            - user:
                id: "38967332"
                relationship: "friend"
              scores:
                recent: 73
                max: 150
                checkinsCount: 23

              rank: 10
            - user:
                id: "25052241"
                relationship: "self"
              scores:
                recent: 61
                max: 123
                checkinsCount: 16
              rank: 11
            - user:
                id: "508984"
                relationship: "friend"
              scores:
                recent: 61
                max: 123
                checkinsCount: 16
              rank: 12

      }
    )
  end

  let(:requests) do
    YAML.load(%{
        meta:
          code: 200
        response:
          requests:
          - id: "6218439"
            firstName: "Manoj"
            lastName: "Shenoy"
            relationship: "pendingMe"
      }
    )
  end

  let(:user_checkins) do
    YAML.load(%{
        meta:
          code: 200
        response:
          checkins:
            counts: 314
            items:
            - id: "50adae47e4b0f1042101c870"
              venue:
              - id: "4b9a2e26f964a5200fa335e3"
      }
    )
  end

  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/users/self?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => me.to_json, :headers => {})
    stub_request(:get, "https://api.foursquare.com/v2/users/leaderboard?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => leaderboard.to_json, :headers => {})
    stub_request(:get, "https://api.foursquare.com/v2/users/requests?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => requests.to_json, :headers => {})
    stub_request(:get, "https://api.foursquare.com/v2/users/self/checkins?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => user_checkins.to_json, :headers => {})
  end

  describe "#user" do
    it "should return a foursquared user response" do
      foursquared_test_client.user.class.should == Foursquared::Response::User
    end
  end

  describe "#leaderboard" do

    it "should return the 'self' user's leaderboard" do
      foursquared_test_client.leaderboard.keys.should include("count", "items")
    end

    describe "each leaderboard item" do
      it "should have a user, scores and rank" do
        foursquared_test_client.leaderboard["items"].should each { |item|
          item.keys.should include("user", "scores", "rank")
        }
      end

      it "should have a user response" do
        foursquared_test_client.leaderboard["items"].should each { |item|
          item["user"].should be_a(Foursquared::Response::User)
        }
      end
    end
  end

  describe "#requests" do
    it "should return user's pending friend requests" do
      foursquared_test_client.requests.should each { |item|
        item.should be_a(Foursquared::Response::User)
      }
    end
  end

  describe "#user_checkins" do
    it "should return given user's checkins" do
      foursquared_test_client.user_checkins["checkins"]["items"].should each { |item|
        item.should be_a(Foursquared::Response::Checkin)
      }
    end
  end
end