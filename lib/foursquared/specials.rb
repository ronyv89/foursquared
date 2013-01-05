module Foursquared
  # Specials module
  module Specials
    # Gives details about a special
    # @param [String] special_id required ID of special to retrieve
    # @param [Hash] options
    # @option options [String] :venueId required ID of a venue the special is running at
    # @option options [String] :userId ID of the user to check whether the special is unlocked for. Only available if the current user is the manager of the venue. If not provided, checks wher the special is unlocked for the current user.
    # @return [Foursquared::Response::Special]
    def special special_id, options={}
      response = get("/specials/#{special_id}")["response"]
      @special = Foursquared::Response::Special.new(self, response["special"])
    end

    # Flag a Special
    # @param [String] special_id required ID of special to flag
    # @param [Hash] options
    # @option option [String] :venueId required The id of the venue running the special.
    # @option option [String] :problem required One of not_redeemable, not_valuable, other.
    # @option option [String] :text Additional text about why the user has flagged this special
    def flag_special special_id, options={}
      response = post("/specials/#{special_id}/flag", options)["response"]
    end
  end
end
