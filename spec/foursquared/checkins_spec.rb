require 'spec_helper'
describe Foursquared::Checkins do 

  let(:checkin) do
    YAML.load(%{
      meta:
        code: 200
      notifications: []
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
            gender: "male"
            photo: 
              prefix: "https://irs0.4sqi.net/img/user/"
              suffix: "/32_1239135232.jpg"
          venue:
            id: "408c5100f964a520c6f21ee3"
            name: "Tompkins Square Park"

    })
  end

  let(:recent_checkins) do
    YAML.load(%{
      meta:
        code: 200
      response:
        recent:
        - id: "50ec9b33e4b0b63dc59108bb"
          createdAt: 1357683507
          type: "checkin"
          shout: "Shadow's photoshoot"
          timeZoneOffset: 330
        - id: "50ec7ad7e4b0beb130e3c6fb"
          createdAt: 1357675223
          type: "checkin"
          timeZoneOffset: 330
    })
  end

  let(:checkin_likes) do
    YAML.load(%{
      meta:
        code: 200
      response:
        likes:
          count: 2
          groups:
          - type: "others"
            count: 2
            items:
            - id: "4006236"
              firstName: "Shane"
              lastName: "O."
              gender: "male"
              photo: 
                prefix: "https://irs3.4sqi.net/img/user/"
                suffix: "/OHXZCLCMRAGXPV3S.jpg"
            - id: "591008"
              firstName: "mi1ky"
              lastName: "L."
              gender: "female"
              photo:
                prefix: "https://irs1.4sqi.net/img/user/"
                suffix: "/UX1JTWSNWY5YV1PS.jpg"
          summary: "2 likes"
    })
  end
  subject { foursquared_test_client }

  describe "#add_checkin" do
    it "should add a new checkin" do
      stub_request(:post, "https://api.foursquare.com/v2/checkins/add?oauth_token=TestToken").
         with(:body => "venueId=408c5100f964a520c6f21ee3&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => checkin.to_json, :headers => {})
      subject.add_checkin({:venueId => "408c5100f964a520c6f21ee3"})[:checkin].should be_a(Foursquared::Response::Checkin)
    end
  end

  describe "#recent_checkins" do
    it "should return the recent checkins for the acting user" do
       stub_request(:get, "https://api.foursquare.com/v2/checkins/recent?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => recent_checkins.to_json, :headers => {})
      subject.recent_checkins.should each {|checkin|
        checkin.should be_a Foursquared::Response::Checkin
      }
    end
  end

  describe "#checkin_likes" do
    before :each do
      stub_request(:get, "https://api.foursquare.com/v2/checkins/502bcde16de4146b7f104ac6/likes?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => checkin_likes.to_json, :headers => {})
    end

    it "should have count, groups and a summary" do
      subject.checkin_likes("502bcde16de4146b7f104ac6").keys.should ~ ["summary", "count", "groups"]
    end

    it "should have give groups of users" do
      subject.checkin_likes("502bcde16de4146b7f104ac6")["groups"].should each { |group|
          group["items"].should each {|item|
            item.should be_a Foursquared::Response::User
          }
      }
    end
  end

end