module Foursquared
  module Checkins
    def checkin(checkin_id,options={})
      response = get("/checkins/#{checkin_id}",options)["response"]
      @checkin = Foursquared::Response::Checkin.new(self, response["checkin"])
    end

    def add_checkin(options={})
      response = post("/checkins/add", options)["response"]
      {:checkin => Foursquared::Response::Checkin.new(self, response["checkin"]), :notifications => Foursquared::Response::Notifications.new(self, response["notifications"])}
    end

    def recent_checkins(options={})
      response = get("/checkins/recent", options)["response"]
      @checkins = response["recent"].collect{|checkin| Foursquared::Response::Checkin.new(self, checkin)}
    end
  end
end