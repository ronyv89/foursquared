module Foursquared
  # Badges module
  module Badges
    # Badge details
    # @param [String] badge_id required, The id of the badge
    # @return [Foursquared::Response::Badge]
    def badge badge_id
      response = get("/badges/#{badge_id}")["response"]
      Foursquared::Response::Badge.new(self,response["badge"])
    end
  end
end