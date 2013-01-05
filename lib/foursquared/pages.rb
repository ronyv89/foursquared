module Foursquared
  # Pages module
  module Pages
    # Return the page with the given ID
    # @param [String] page_id ID of the page
    # @return [FOursquared::Response::User]
    def page page_id
      response  = get("/pages/#{page_id}")["response"]
      @page = Foursquared::Response::User.new(self, response["user"])
    end

    # Search Pages
    # @param [Hash] options
    # @option options [String] :name  A search term to be applied against page names.
    # @option options [String] :twitter A comma-delimited list of Twitter handles to look for.
    # @option options [String] :fbid A comma-delimited list of Facebook ID's to look for.
    def page_search options={}
      response = get("/pages/search",options)["response"]
      @pages = response.collect{|result| Foursquared::Response::User.new(self, result)}
    end

    # Returns the page's venues.
    # @param [String] page_id ID of the page
    # @param [Hash] options
    # @option options [String] :ll Not valid with ne or sw. Limits results to venues near this latitude and longitude within an optional radius.
    # @option options [String] :radius Not valid with ne or sw. Limit results to venues within this many meters of the specified ll
    # @option options [String] :sw With ne, limits results to the bounding quadrangle defined by the latitude and longitude given by sw as its south-west corner, and ne as its north-east corner.
    # @option options [String] :ne See sw
    # @option options [Integer] :offset The offset of which venues to return. Defaults to 0.
    # @option options [String] :limit The number of venues to return. Defaults to 20, max of 100.
    # @return [Hash] Count and items of venues
    def page_venues page_id, options={}
      @venues = get("/pages/#{page_id}/venues", options)["response"]["venues"]
      @venues["items"].map!{|item| Foursquared::Response::Venue.new(self, item)}
      @venues
    end

    # Like or unlike a page
    # @param [String] page_id ID of the page to like or unlike.
    # @param [Hash] options
    # @option options [Integer] :set If 1, like this page. If 0 unlike (un-do a previous like) it. Default value is 1.
    # @return [Foursquared::Response::User]
    def like_page page_id, options={}
      response = post("/pages/#{page_id}/like",options)["response"]
      @page = Foursquared::Response::User.new(self, response["user"])
    end

  end
end
