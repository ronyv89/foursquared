module Foursquared
  module Response
    # Checkin response
    class Checkin
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      # ID of the checkin
      # @return [String]
      def id
        response["id"]
      end

      # The time at which the checkin was created
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # One of checkin, shout, or venueless.
      # @return [String]
      def type
        response["type"]
      end

      # If present, it indicates the checkin was marked as private and not sent to friends
      def private
        response["private"]
      end

      # If the user is not clear from context, then a compact user is present
      # @return [Foursquared::Response::User]
      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      # The current location of the user
      # @return [Hash]
      def location
        response["location"]
      end

      # Optional count and items of checkins from friends checked into the same venue around the same time.
      # @return [Hash]
      def overlaps
        @overlaps = response["overlaps"]
        @overlaps["items"].map!{|item| Foursquared::Response::Checkin.new(client, item)} if @overlaps
        @overlaps
      end

      # Count and items for comments on this checkin.
      # @return [Hash]
      def comments
        response["comments"]
      end

      # Full list of comments for this checkin
      # @return [Hash]
      def full_comments
        client.get("/checkin/#{id}/comments")["comments"]
      end

      # Message from check-in, if present and visible to the acting user.
      # @return [String]
      def shout
        response["shout"]
      end

      # If present, the name and url for the application that created this checkin.
      # @return [Hash]
      def source
        response["source"]
      end

      # Total and scores for this checkin
      # @return [Hash]
      def score
        response["score"]
      end

      # Whether the acting user likes the checkin
      # @return [Boolean]
      def like?
        response["like"]
      end

      # String representation of the time zone where this check-in occurred.
      # @return [String]
      def time_zone_offset
        response["timeZoneOffset"]
      end

      # The venue of checkin
      # @return [Foursquared::Response::Venue]
      def venue
        Foursquared::Response::Venue.new(client, response["venue"])
      end

      # Count and items for photos on this checkin
      # @return [Hash]
      def photos
        @photos = response["photos"]
        @photos["photos"]["items"].map!{|item| Foursquared::Response::Photo.new(client, item)} if response["photos"]
        @photos
      end

      # Groups of users who have liked the checkin
      # @return [Hash]
      def likes
        @likes = response["likes"]
        @likes["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        @likes
      end

      # The full groups of users who have liked the checkin
      # @return [Hash]
      def full_likes
        @likes = client.get("/checkins/#{id}/likes")["response"]["likes"]
        @likes["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        @likes
      end

      # The count and items of photos associated with the checkin
      # @return [Hash]
      def photos
        @photos = response["photos"]
        @photos["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
        @photos
      end

      # The count and items of all the photos associated with the checkin
      # @return [Hash]
      def full_photos
        resp = get("/checkins/#{id}/photos")
        @photos = resp["photos"]
        @photos["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
        @photos
      end

      # Add a comment to a check-in 
      # @param [Hash] options
      # @option options [String] :text The text of the comment, up to 200 characters.
      # @option options [String] :mentions Mentions in your check-in.
      def add_comment options={}
        response = post("/checkins/#{id}/addcomment", options)["response"]
        @comment = response["comment"]
        @comment["user"] = Foursquared::Response::User.new(client, @comment["user"])
        @comment
      end

      # Remove commment from check-in
      # @param [Hash] options
      # @option options [String] :commentId The ID of the checkin to remove a comment from.
      # @return [Foursquared::Response::Checkin] The checkin, minus this comment.
      def delete_comment options={}
        response = post("/checkins/#{id}/deletecomment", options)["response"]
        @checkin = Foursquared::Response::Checkin.new(client, response["checkin"])
      end

      # Like or unlike a checkin
      # @param [Hash] options
      # @option options [Integer] :set If 1, like this checkin. If 0 unlike (un-do a previous like) it. Default value is 1.
      def like options={}
        response =  post("/checkins/#{id}/like", options)["response"]["likes"]
        response["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        response
      end

    end
  end
end