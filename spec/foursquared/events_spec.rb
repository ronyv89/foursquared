require 'spec_helper'
require 'foursquared/events'

describe Foursquared::Events do
  let(:event) do
    YAML.load(%{
        meta:
          code: 200
        response:
          event:
            venueId: "40afe980f964a5203bf31ee3"
            id: "5093492991d4a3bd84c82646"
            name: "Skyfall: The IMAX Experience"
            foreignIds:
              count: 1
              items:
              - domain: "fandango.com"
                id: "5826-153164"
            hereNow:
              count: 0
              groups:
              - type: "friends"
                name: "Friends here"
                count: 0
                items: []
              - type: "others"
                name: "Other people here"
                count: 0
                items: []
            allDay: true
            date: 1355115600
            timeZone: "America/New_York"
            stats:
              checkinsCount: 9
              usersCount: 9
            url: "https://foursquare.com/events/movies?theater=AAORE&movie=153164&wired=true"
      }
    )
  end
  subject { foursquared_test_client }

  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/events/5093492991d4a3bd84c82646?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").to_return(:status => 200, :body => event.to_json, :headers => {})
  end

  it "should return the event with the given id" do
    subject.event("5093492991d4a3bd84c82646").should be_a Foursquared::Response::Event
  end

end