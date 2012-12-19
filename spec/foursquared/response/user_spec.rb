require 'spec_helper'
require 'foursquared/response/user'
require 'foursquared/response/list'

require 'foursquared/client'
require 'core_ext/symbol'
describe Foursquared::Response::User do
  let(:me) do
    YAML.load(%{
      meta:
        code: 200
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
          lists:
            count: 5
            groups:
            - type: "created"
              count: 3
              items:
              - id: "25052241/todos"
                name: "My to-do list"
                description: ""
                user:
                  id: "25052241"
                  firstName: "Rony"
                  lastName: "Varghese"
                  relationship: "self"
                  photo:
                      prefix: "https://irs1.4sqi.net/img/user/"
                      suffix: "/HE1OX3T3S3HN5OI4.jpg"
                editable: false
                public: false
                collaborative: false
                url: "https://foursquare.com/user/25052241/list/todos"
                canonicalUrl: "https://foursquare.com/user/25052241/list/todos"
                followers:
                    count: 0
                listItems:
                    count: 0
      }
    )
  end
  subject { foursquared_test_client.user("self") }
  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/users/self?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => me.to_json, :headers => {})
  end

  it "should get user's id" do
    subject.id.should == "12345678"
  end

  it "should return user's firstname" do
    subject.first_name.should == "Rony"
  end

  it "shoyld return user's last name" do
    subject.last_name.should == "Varghese"
  end

  it "should give the relationship between 'me' and the current user" do
    subject.relationship.should == "self"
  end

  describe "#friends" do
    it "should return the user's friends" do
      subject.friends["groups"].should each { |group|
          group["items"].should be_empty_or_array_of_users
      }
    end

    it "should have different type of friends" do
      subject.friends["groups"].collect{ |group| group["type"] }.should be_unique
    end
  end

  describe "#lists" do
    it "should return the user's lists" do
      subject.lists["groups"].should each { |group|
          group["items"].should be_empty_or_array_of_lists
      }
    end
  end


end