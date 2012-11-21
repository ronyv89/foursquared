# require 'foursquared/users'
# require 'foursquared/lists'
# require 'foursquared/venues'
# require 'foursquared/photos'
# require 'foursquared/client'
require 'spec_helper'
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

  end
  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/users/self?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => me.to_json, :headers => {})
  end
  describe "#user" do
    it "should return a foursquared user response" do
      foursquared_test_client.user.class.should == Foursquared::Response::User
    end
  end

  # describe "#leaderboard" do
  #   it "should return the 'self' user's leaderboard" do
  #     foursquared_test_client.leaderboard.class.should == Foursquared::Response::Leaderboard
  #   end
  # end

end