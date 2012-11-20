module Foursquared
  module Venues
    def venue(venue_id)
      response = get("/venues/#{venue_id}")["response"]
      @venue = Foursquared::Response::Venue.new(self, response["venue"])
    end
  end
end