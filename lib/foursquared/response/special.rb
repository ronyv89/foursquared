module Foursquared
  module Response
    # Special response
    class Special
      attr_reader :client, :response

      def initialize client, response
        @client = client
        @response = response
      end

      # ID of the special
      # @return [String]
      def id
        response["id"]
      end

      # A description of how to unlock the special.
      # @return [String]
      def description
        response["description"]
      end

      # One of mayor, count, frequency, regular, friends, swarm, flash or other.
      # @return [String]
      def type
        response["type"]
      end

      # A message describing the special.
      # @return [String]
      def message
        response["message"]
      end

      # Special's image urls
      # @return [Hash]
      def image_urls
        response["imageUrls"]
      end

      # If the user has unlocked the special
      # @return [Boolean]
      def unlocked?
        response["unlocked"]
      end

      # The name of the icon to use
      # @return [String]
      def icon
        response["icon"]
      end

      # URL for the icon
      # @return [String]
      def icon_url
        "http://foursquare.com/img/specials/#{icon}.png" if icon
      end

      # The header text describing the type of special.
      # @return [String]
      def title
        response["title"]
      end

      # The state of the special
      # @return [String] unlocked, before start, in progress, taken, or locked
      def state
        response["state"]
      end

      # A description of how close you are to unlocking the special
      # @return [Integer] Either the number of people who have already unlocked the special (flash and swarm specials), or the number of your friends who have already checked in (friends specials)
      def progress
        response["progress"]
      end

      # A label describing what the number in the progress field means.
      # @return [String]
      def progress_description
        response["progressDescription"]
      end

      # Minutes remaining until the special can be unlocked
      # @return [String]
      def detail
        response["detail"]
      end

      # The provider of the special
      # @return [String]
      def provider
        response["provider"]
      end

      # Type of redemption
      # @return [String]
      def redemption
        response["redemption"]
      end

      # The count and urls for the images for the special
      # @return [Hash]
      def image_urls
        response["imageUrls"]
      end

      # The specific rules for this special.
      # @return [String]
      def fine_print
        response["finePrint"]
      end

      # Friends who are here
      # @return [Array<Foursquared::Response::User>] An array of Users
      def friends_here
        @friends = response["friendsHere"].collect{|friend| Foursquared::Response::User.new(client, friend)}
      end

      # Flag the Special
      # @param [Hash] options
      # @option option [String] :venueId required The id of the venue running the special.
      # @option option [String] :problem required One of not_redeemable, not_valuable, other.
      # @option option [String] :text Additional text about why the user has flagged this special
      def flag options={}
        response = post("/specials/#{id}/flag", options)["response"]
      end

    end
  end
end