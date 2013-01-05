module Foursquared
  # Events module
  module Events
    # Return the event with the give ID
    # @return [Foursquared::Response::Event]
    def event event_id
      response = get("/events/#{event_id}")["response"]
      Foursquared::Response::Event.new(self,response["event"])
    end

    # Return the available event categories
    # @return [Array] An array of event categories
    def event_categories
      response = get("/events/categories")["response"]
      response["categories"].collect{|category| Foursquared::Response::Category.new(category)}
    end
  end
end