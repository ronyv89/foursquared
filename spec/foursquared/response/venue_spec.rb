require 'spec_helper'
require 'foursquared/response/user'
require 'foursquared/response/list'

require 'foursquared/client'

describe Foursquared::Response::Venue do
  let(:venue) do
    YAML.load(%{
        meta:
          code: 200
        response:
          venue:
            id: "40a55d80f964a52020f31ee3"
            name: "Clinton Street Baking Co."
            contact:
              phone: "+16466026263"
              formattedPhone: "+1 646-602-6263"
            location:
              address: "4 Clinton St."
              crossStreet: "at E Houston St."
              lat: 40.721294
              lng: -73.983994
              postalCode: "10002"
              city: "New York"
              state: "NY"
              country: "United States"
              cc: "US"
            verified: false
            stats:
              checkinsCount: 9233
              usersCount: 6835
              tipCount: 244
            url: "http://www.clintonstreetbaking.com"
            like: false
            dislike: false
            rating: 9.69

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

  subject { foursquared_test_client.venue("40a55d80f964a52020f31ee3")}

  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => venue.to_json, :headers => {})
    stub_request(:get, "https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3/likes?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => likes.to_json, :headers => {})
  end

  it "should return the likes for the venue" do
    subject.likes["groups"].should each { |group|
        group["items"].should be_empty_or_array_of_users
    }

  end
end