module Foursquared
  # photos module
  module Photos
    def photo photo_id
      response = get("/photos/#{photo_id}")["response"]
      @photo = Response::Photo.new(self, response["photo"])
    end

    def add_photo options={}
      response = post("/photos/add", options)["response"]
      @photo = Response::Photo.new(self, response["photo"])
    end
  end
end