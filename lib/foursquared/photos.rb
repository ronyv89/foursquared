module Foursquared
  module Photos
    def photo(photo_id=nil)
      response = get("/photos/#{photo_id}")["response"]
      @photo = Foursquared::Response::Photo.new(response["photo"])
    end
  end
end