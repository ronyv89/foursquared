require 'pp'
module Foursquared
  # Events module
  module Events
    def event(event_id)
      response = get("/events/#{event_id}")["response"]
      Foursquared::Response::Event.new(self,response["event"])
    end

    def event_categories
      response = get("/events/categories")["response"]
      response["categories"].collect{|category| Foursquared::Response::Category.new(category)}
    end
  end
end