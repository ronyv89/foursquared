module Foursquared
  module Specials
    def special special_id, options={}
      response = get("/specials/#{special_id}")["response"]
      @special = Foursquared::Response::Special(self, response["special"])
    end

  end
end
