# Foursquared module
module Foursquared
  # Venues module
  module Venues
    # Venue detail
    # @param [String] venue_id ID of venue to retrieve
    # @return [Foursquared::Response::Venue]
    def venue venue_id
      response = get("/venues/#{venue_id}")["response"]
      @venue = Foursquared::Response::Venue.new(self, response["venue"])
    end

    # Add a venue
    # @param [Hash] options
    # @option options [String] :name required The name of the venue
    # @option options [String] :address The address of the venue
    # @option options [String] :crossStreet The nearest intersecting street or streets.
    # @option options [String] :city The city name where this venue is.
    # @option options [String] :state The nearest state or province to the venue.
    # @option options [String] :zip The zip or postal code for the venue.
    # @option options [String] :phone The phone number of the venue.
    # @option options [String] :twitter The twitter handle of the venue.
    # @option options [String] :ll required Latitude and longitude of the venue, as accurate as is known.
    # @option options [String] :primaryCategoryId The ID of the category to which you want to assign this venue.
    # @option options [String] :description A freeform description of the venue, up to 300 characters.
    # @option options [String] :url The url of the homepage of the venue.
    # @option options [Boolean] :ignoreDuplicates A boolean flag telling the server to ignore duplicates and force the addition of this venue.
    # @option options [String] :ignoreDuplicatesKey Required if ignoreDuplicates is true. This key will be available in the response of the HTTP 409 error of the first (failed) attempt to add venue.
    def add_venue options={}
      response = post("/venues/add", options)["response"]
      Foursquared::Response::Venue.new(self, response["venue"])
    end

    
  end
end