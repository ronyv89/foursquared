require 'spec_helper'
require 'foursquared/response/checkin'
require 'foursquared/client'
require 'pp'
describe Foursquared::Response::Checkin do
  let(:checkin) do
    YAML.load(%{
        meta:
          code: 200
        response:
          checkin:
            id: "4d627f6814963704dc28ff94"
            createdAt: 1298300776
            type: "checkin"
            shout: "Another one of these days. #snow"
            timeZoneOffset: -300
            user:
              id: "32"
              firstName: "Dens"
            venue:
              id: "408c5100f964a520c6f21ee3"
              name: "Tompkins Square Park"
            source:
              name: "foursquare for iPhone"
              url: "https://foursquare.com/download/#/iphone"
            photos:
              count: 1
              items:
              - id: "4d627f80d47328fd96bf3448"
                createdAt: 1298300800
                prefix: "https://irs3.4sqi.net/img/general/"
                suffix: "/UBTEFRRMLYOHHX4RWHFTGQKSDMY14A1JLHURUTG5VUJ02KQ0.jpg"
            likes:
              count: 1
              groups: 
              - type: "others"
                count: 1
                items:
                - id: "141623"
                  firstName: "chad"
                  lastName: "g."
            like: false
            score:
            - total: 1
              scores:
              - points: 1
                icon: "https://foursquare.com/img/points/defaultpointsicon2.png"
                message: "Every check-in counts!"
      }
    )
  end

  let(:likes) do
    YAML.load(%{
        meta:
          code: 200
        response:
          likes:
            count: 42
            groups:
            - type: "others"
              count: 42
              items:
              - id: "141623"
                firstName: "chad"
                lastName: "g."
                photo:
                  prefix: "https://irs2.4sqi.net/img/user/"
                  suffix: "/X521V5IIEPN2Y3F5.jpg"
              - id: "16066"
                firstName: "Allan"
                lastName: "B."
      }
    )
  end

  subject { foursquared_test_client.checkin("4d627f6814963704dc28ff94") }

  before :each do

    stub_request(:get, "https://api.foursquare.com/v2/checkins/4d627f6814963704dc28ff94?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => checkin.to_json, :headers => {})
  end

  it "should get checkin id" do
    subject.id.should == "4d627f6814963704dc28ff94"
  end

  it "should get the checkin venue" do
    subject.venue.should be_a(Foursquared::Response::Venue)
  end

  describe "likes for the checkin" do
    describe "#full_likes" do
      it "should get the full likes for the checkin" do
        stub_request(:get, "https://api.foursquare.com/v2/checkins/4d627f6814963704dc28ff94/likes?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => likes.to_json, :headers => {})
        subject.full_likes["groups"].should each { |group|
          group["items"].should each { |item|
            item.should be_a(Foursquared::Response::User)
          }
        }
      end
    end

    describe "#likes" do
      it "should return the likes as specified in the checkin response" do
        subject.likes["groups"].should each { |group|
          group["items"].should each { |item|
            item.should be_a(Foursquared::Response::User)
          }
        }
      end
    end
  end

  it "should return the photos for the checkin" do
    subject.photos["items"].should each { |item|
      item.should be_a Foursquared::Response::Photo
    }
  end
end