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
      response["categories"].collect{|category| Foursquared::Response::Category.new(self, category)}
    end

    # Create an event for a venue that you manage.
    # @param [Hash] options
    # @option options [String] :venueId The id of the venue where the event is being held.
    # @option options [String] :name The name of the event
    # @option options [String] :start Time when the event is scheduled to start, in seconds since Unix epoch.
    # @option options [String] :end Time when the event is scheduled to end, in seconds since Unix epoch.
    def add_event
      response = post("/events/categories")["response"]
      Foursquared::Response::Event.new(self, response["event"])
    end

  end
end