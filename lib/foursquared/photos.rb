module Foursquared
  module Photos
    def photo(photo_id)
      response = get("/photos/#{photo_id}")["response"]
      @photo = Response::Photo.new(self, response["photo"])
    end
  end
end