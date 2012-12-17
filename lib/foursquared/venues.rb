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

    # Returns a hierarchical list of categories applied to venues.
    # @return [Array]
    def venue_categories
      response = get("/venues/categories")["response"]
      response["categories"].collect{|category| Foursquared::Response::Category.new(self, category) }
    end

    # Explore Recommended and Popular Venues
    # @param [Hash] options
    # @option options [String] :ll required unless :near is provided. Latitude and longitude of the user's location.
    # @option options [String] :near required unless :ll is provided. A string naming a place in the world
    # @option options [String] :llAcc Accuracy of latitude and longitude, in meters.
    # @option options [String] :alt Altitude of the user's location, in meters.
    # @option options [String] :altAcc Accuracy of the user's altitude, in meters.
    # @option options [String] :radius Radius to search within, in meters.
    # @option options [String] :section One of food, drinks, coffee, shops, arts, outdoors, sights, trending or specials, nextVenues or topPicks
    # @option options [String] :query A term to be searched against a venue's tips, category, etc.
    # @option options [Integer] :limit Number of results to return, up to 50.
    # @option options [Integer] :offset Used to page through results.
    # @option options [String] :novelty Pass new or old to limit results to places the acting user hasn't been or has been, respectively.
    # @option options [String] :friendVisits Pass visited or notvisited to limit results to places the acting user's friends have or haven't been, respectively.
    # @option options [String] :venuePhotos Boolean flag to include a photo in the response for each venue, if one is available (1/0)
    # @option options [String] :lastVenue A venue ID to use in combination with the intent=nextVenues parameter, which returns venues users often visit after a given venue.
    def explore_venues options={}
      response = get("/venues/explore", options)["response"]
      response["groups"].each do |group|
        response["items"].each do |item|
          item["venue"] = Foursquared::Response::Venue.new(self, item["venue"])
          item["tips"].map!{|tip| Foursquared::Response::List.new(self, tip)}
        end
      end
      response
    end

    # Get a list of venues the current user manages.
    # @return [Array] An array of compact venues the user manages.
    def managed_venues
      response = get("/venues/managed")["response"]
      @venues = response["venues"].collect{|venue| Foursquared::Response::Venue.new(self, venue)}
    end

    # Returns a list of venues near the current location, optionally matching a search term.
    # @param [Hash] options
    # @option options [String] :ll required unless :near is provided. Latitude and longitude of the user's location.
    # @option options [String] :near required unless :ll is provided. A string naming a place in the world
    # @option options [String] :llAcc Accuracy of latitude and longitude, in meters.
    # @option options [String] :alt Altitude of the user's location, in meters.
    # @option options [String] :altAcc Accuracy of the user's altitude, in meters.
    # @option options [String] :radius Radius to search within, in meters.
    # @option options [String] :query A search term to be applied against venue names.
    # @option options [Integer] :limit Number of results to return, up to 50.
    # @option options [String] :intent Checkout https://developer.foursquare.com/docs/venues/search for the possible values
    # @option options [String] :sw Checkout https://developer.foursquare.com/docs/venues/search for details
    # @option options [String] :ne Checkout https://developer.foursquare.com/docs/venues/search for details
    # @option options [String] :categoryId A comma separated list of categories to limit results to
    # @option options [String] :url A third-party URL which we will attempt to match against our map of venues to URLs
    # @option options [String] :providerId Identifier for a known third party that is part of our map of venues to URLs
    # @option options [String] :linkedId Identifier used by third party specified in providerId, which we will attempt to match against our map of venues to URLs
    # @return [Array] An array of compact venues.
    def search_venues options={}
      response = get("/venues/search", options)["response"]
      @venues = response["venues"].collect{|venue| Foursquared::Response::Venue.new(self, venue)}
    end

    # Returns a list of venues near the current location with the most people currently checked in.
    # @param [Hash] options
    # @option options [String] :ll required Latitude and longitude of the user's location.
    # @option options [Integer] :limit Number of results to return, up to 50.
    # @option options [Integer] :radius Radius in meters, up to approximately 2000 meters.
    # @return [Array] An array of venues that are currently trending, with their hereNow populated.
    def trending_venues options={}
      response = get("/venues/trending", options)["response"]
      @venues = response["venues"].collect{|venue| Foursquared::Response::Venue.new(self, venue)}
    end

    # Gives information about the current events at a place.
    # @param [String] venue_id required The venue id for which events are being requested.
    # @return [Hash] A count and items of event items. Also includes a "summary" string describing the set of events at the venue.
    def venue_events venue_id
      response = get("/venues/#{venue_id}/events")["response"]
      @events = response["events"]
      @events["items"].map!{|item| Foursquared::Response::Event.new(self, item)}
      @events
    end

    # Returns hours for a venue.
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @return [Array] An array of timeframes of hours.
    def venue_hours venue_id
      response = get("/venues/#{venue_id}/hours")["response"]["hours"]
    end

    # Users who have liked a venue
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @return [Hash] A count and groups of users who like this venue
    def venue_likes venue_id
      response = get("/venues/#{venue_id}/likes")["response"]["likes"]
      response["groups"].each do |group|
        response["items"].map!{|item| Foursquared::Response::User.new(self, item)}
      end
      response
    end

    # The lists that this venue appears on.
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @param [Hash] options
    # @option options [String] :group Can be created, edited, followed, friends, other.
    # @option options [Integer] :limit Number of results to return, up to 200.
    # @option options [Integer] :offset Used to page through results. Must specify a group
    # @return [Hash]
    def venue_lists venue_id, options={}
      response = get("/venues/#{venue_id}/lists", options)["response"]["lists"]
      if response["groups"]
        response["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::Lists.new(self, item)} if group["items"]
        end
      else
        response["items"].map!{|item| Foursquared::Response::Lists.new(self, item)}
      end
      response
    end

    # Returns photos for a venue.
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @param [Hash] options
    # @option options [String] :group required  Pass checkin for photos added by friends (including on their recent checkins). Pass venue for public photos added to the venue by non-friends. Use multi to fetch both.
    # @option options [Integer] :limit Number of results to return, up to 200.
    # @option options [Integer] :offset Used to page through results
    # @return [Hash] A count and items of photos
    def venue_photos venue_id, options={}
      response = get("/venues/#{venue_id}/photos", options)["response"]["photos"]
      response["items"].map!{|item| Foursquared::Response::Photo.new(self, item)}
      response
    end

    # Returns a list of venues similar to the specified venue.
    # @param [String] venue_id required The venue you want similar venues for.
    # @return [Hash] A count and items of similar venues.
    def venue_likes venue_id
      response = get("/venues/#{venue_id}/similar")["response"]["similarVenues"]
      response["items"].map!{|item| Foursquared::Response::Venue.new(self, item)}
      response
    end

    # Flag a Venue
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @param [Hash] options
    # @option options [String] :problem required One of mislocated, closed, duplicate, inappropriate, doesnt_exist, event_over
    # @option options [String] :venueId ID of the duplicated venue (for problem duplicate)
    def flag_venue venue_id, options={}
      response = post("/venues/#{venue_id}/flag", options)
    end

    # Like or unlike a venue
    # @param [String] venue_id required The venue id for which hours are being requested.
    # @param [Hash] options
    # @option options [Integer] :set If 1, like this venue. If 0 unlike (un-do a previous like) it. Default value is 1.
    # @return [Hash] Updated count and groups of users who like this venue
    def like_venue venue_id, options={}
      response = post("/venues/#{venue_id}/like", options)["response"]["likes"]
      response["groups"].each do |group|
        response["items"].map!{|item| Foursquared::Response::User.new(self, item)}
      end
      response
    end

    # Propose an Edit to a Venue
    # @param [Hash] options
    # @option options [String] :name The name of the venue
    # @option options [String] :address The address of the venue
    # @option options [String] :crossStreet The nearest intersecting street or streets.
    # @option options [String] :city The city name where this venue is.
    # @option options [String] :state The nearest state or province to the venue.
    # @option options [String] :zip The zip or postal code for the venue.
    # @option options [String] :phone The phone number of the venue.
    # @option options [String] :ll Latitude and longitude of the venue, as accurate as is known.
    # @option options [String] :primaryCategoryId The ID of the category to which you want to assign this venue.
    # @option options [String] :hours The hours for the venue, as a semi-colon separated list of open segments and named segments
    def propose_venue_edit venue_id, options={}
      response = post("/venues/#{venue_id}", options)
    end
  end
end