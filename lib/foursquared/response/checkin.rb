module Foursquared
  module Response
    # Checkin response
    class Checkin
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :type, :shout, :source, :score, :like].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      def time_zone_offset
        response["timeZoneOffset"]
      end

      def venue
        Foursquared::Response::Venue.new(client, response["venue"])
      end

      def photos
        response["photos"]["items"].collect{|photo| Foursquared::Response::Photo.new(client, photo)}
      end

      def likes
        response = client.get("/checkins/#{id}/likes")["response"]["likes"]
        response["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        response
      end

      def photos
        response["photos"]["items"].collect{|item| Foursquared::Response::Photo.new(client, item)}
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