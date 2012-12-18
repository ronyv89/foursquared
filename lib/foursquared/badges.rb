module Foursquared
  module Badges
    def badge(badge_id)
      response = get("/badges/#{badge_id}")["response"]
      Foursquared::Response::Badge.new(self,response["badge"])
    end
  end
end