# Foursquared module
module Foursquared
  # Checkins module
  module Checkins

    # Get details of a checkin. 
    # @param [String] checkin_id The ID of the checkin to retrieve additional information for.
    # @param [Hash] options
    # @option options [String] :signature
    # @return [Foursquared::Response::Checkin] A checkin object
    def checkin checkin_id, options={}
      response = get("/checkins/#{checkin_id}",options)["response"]
      @checkin = Foursquared::Response::Checkin.new(self, response["checkin"])
    end

    # Create a check-in 
    # @param [Hash] options
    # @option options [String] :venueId required The venue where the user is checking in.
    # @option options [String] :eventId The event the user is checking in to.
    # @option options [String] :shout A message about your check-in
    # @option options [String] :mentions Semicolon-delimited list of mentions
    # @option options [String] :broadcast Who to broadcast this check-in to
    # @option options [String] :ll Latitude and longitude of the user's location.
    # @option options [String] :llAcc Accuracy of the user's latitude and longitude, in meters
    # @option options [String] :alt Altitude of the user's location, in meters.
    # @option options [String] :altAcc Vertical accuracy of the user's location, in meters.
    # @return [Foursquared::Response::Checkin] A checkin object
    def add_checkin options={}
      response = post("/checkins/add", options)["response"]
      {:checkin => Foursquared::Response::Checkin.new(self, response["checkin"]), :notifications => response["notifications"]}
    end

    # Recent checkins by friends
    # @param [Hash] options
    # @option options [String] :ll Latitude and longitude of the user's location, so response can include distance
    # @option options [Integer] :limit Number of results to return, up to 100.
    # @option options [Integer] :afterTimestamp Seconds after which to look for checkins
    # @return [Array] An array of checkin objects with user details present
    def recent_checkins options={}
      response = get("/checkins/recent", options)["response"]
      @checkins = response["recent"].collect{|checkin| Foursquared::Response::Checkin.new(self, checkin)}
    end

    # Users who have liked a checkin
    # @param [String] checkin_id The ID of the checkin to get likes for.
    # @return [Hash] A count and groups of users who like this checkin
    def checkin_likes checkin_id
      @likes = get("/checkins/#{checkin_id}/likes")["response"]["likes"]
      @likes["groups"].each do |group|
        group["items"].map!{|item|Foursquared::Response::User.new(self, item)}
      end
      @likes
    end

    # Add a comment to a check-in 
    # @param [String] checkin_id The ID of the checkin to add a comment to.
    # @param [Hash] options
    # @option options [String] :text The text of the comment, up to 200 characters.
    # @option options [String] :mentions Mentions in your check-in.
    # @return [Hash] The newly-created comment.
    def add_checkin_comment checkin_id, options={}
      response = post("/checkins/#{checkin_id}/addcomment", options)["response"]
      @comment = response["comment"]
      @comment["user"] = Foursquared::Response::User.new(self, @comment["user"])
      @comment
    end

    # Remove commment from check-in
    # @param [String] checkin_id The ID of the checkin to remove a comment from.
    # @param [Hash] options
    # @option options [String] :commentId
    # @return [Foursquared::Response::Checkin] The checkin, minus this comment.
    def delete_checkin_comment checkin_id, options={}
      response = post("/checkins/#{checkin_id}/deletecomment", options)["response"]
      @checkin = Foursquared::Response::Checkin.new(self, response["checkin"])
    end

    # Like or unlike a checkin
    # @param [String] checkin_id The ID of the checkin to like
    # @param [Hash] options
    # @option options [Integer] :set If 1, like this checkin. If 0 unlike (un-do a previous like) it. Default value is 1.
    def like_checkin checkin_id, options={}
      response =  post("/checkins/#{checkin_id}/like", options)["response"]["likes"]
      response["groups"].each do |group|
        group["items"].map!{|item| Foursquared::Response::User.new(self, item)}
      end
      response
    end
  end
end