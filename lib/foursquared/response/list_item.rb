module Foursquared
  module Response
    # List item response
    class ListItem
      attr_reader :client, :response

      def initialize client, response
        @client = client
        @response = response
      end


      # ID of the list item
      # @return [String]
      def id
        response["id"]
      end

      # The time at which the list item was created
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # Tip, if present, in the list
      # @return [Foursquared::Response::Tip]
      def tip
        Foursquared::Response::Tip.new(client, response["tip"]) if response["tip"]
      end

      # Venue, if present, in the list
      # @return [Foursquared::Response::Venue]
      def venue
        Foursquared::Response::Venue.new(client, response["venue"]) if response["venue"]
      end

      # Text entered by the user when creating this item
      # @return [String]
      def note
        response["note"]
      end

      # User who added this item to the current list
      # @return [Foursquared::Response::User]
      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      # A photo for this list item
      # @return [Foursquared::Response::Photo]
      def photo
        Foursquared::Response::Photo.new(client, response["photo"]) if response["photo"]
      end

      # Information about what other lists this item appears on
      # @return [Array] array of compact lists
      def listed
        response["listed"].collect{|item| Foursquared::Response::List.new(item)} if response["listed"]
      end

    end
  end
end