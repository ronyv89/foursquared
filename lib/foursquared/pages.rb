module Foursquared
  module Pages
    def page page_id
      response  = get("/pages/#{page_id}")["response"]
      @page = Foursquared::Response::User.new(self, response["user"])
    end

    def page_search options={}
      response = get("/pages/search",options)["response"]
      @pages = response.collect{|result| Foursquared::Response::User.new(self, result)}
    end

    def page_venues page_id, options={}
      response = get("/pages/#{page_id}/venues", options)["response"]
      @venues = response["venues"]["items"].collect{|item| Foursquared::Response::Venue.new(self, item)}
    end

    def page_like page_id, options={}
      response = get("/pages/#{page_id}/like",options)["response"]
      @page = Foursquared::Response::User.new(self, response["user"])
    end
  end
end
