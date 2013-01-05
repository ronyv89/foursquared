module Foursquared
  module Response
    # Badge group response
    class BadgeGroup
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      # The type of badge group
      # @return [String]
      def type
        response["type"]
      end

      # Name of the badge group
      # @return [String]
      def name
        response["name"]
      end

      # Image for the badge group
      # @return [Hash]
      def image
        response["image"]
      end

      # Array of IDs of badges present in the group
      # @return [Array<String>]
      def items
        response["items"]
      end

      # Sub groups of the group
      # @return [Array<Foursquared::Response::BadgeGroup>]
      def groups
        response["groups"].map!{|group| Foursquared::Response::BadgeGroup.new(client, group)}
      end
    end
  end
end