module Foursquared
  module Response
    # Photo response
    class Photo
      attr_reader :client, :response
      def initialize(client, response)
        @client = client
        @response = response
      end

      # The ID of the photo
      # @return [String]
      def id
        response["id"]
      end

      # The time at which the photo was created
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # The name and url for the application that created this photo.
      def source
        response["source"]
      end

      # Start of the URL for this photo.
      # @return [String]
      def prefix
        response["prefix"]
      end

      # End of the URL for this photo.
      # @return [String]
      def suffix
        response["suffix"]
      end

      # The user to which the photo belongs
      # @return [Foursquared::Response::User]
      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      # URLs for each photo size
      # @return [Hash]
      def urls
        @urls = {
          "36x36" => url(36,36),
          "100x100" => url(100,100),
          "300x300" => url(300,300),
          "500x500" => url(500,500)
        }
        @urls.merge!({"original" => url(width, height)}) if (width and height)
        @urls
      end

      # Height of the original photo in pixels
      # @return [Integer]
      def height
        response["height"]
      end

      # Width of the original photo in pixels
      # @return [Integer]
      def width
        response["width"]
      end

      # Who all can see the photo
      # @return [String]
      def visibility
        response["visibility"]
      end

      # Venue at which the photo was taken
      # @return [Foursquared::Response::Venue]
      def venue
        Foursquared::Response::Venue.new(client, response["venue"]) if response["venue"]
      end

      # Tip corresponding to the photo
      # @return [Foursquared::Response::Tip]
      def tip
        Foursquared::Response::Tip.new(client, response["tip"]) if response["tip"]
      end

      # The checkin for which the photo was taken
      # @return [Foursquared::Response::Checkin]
      def checkin
        Foursquared::Response::Checkin.new(client, response["checkin"]) if response["checkin"]
      end

      private
      def url width, height
        "#{prefix}#{width}x#{height}#{suffix}"
      end
    end
  end
end

