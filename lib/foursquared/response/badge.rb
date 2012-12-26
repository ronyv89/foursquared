module Foursquared
  module Response
    # Badge response
    class Badge
      attr_reader :client, :response
      def initialize client, response
        @client  = client
        @response = response
      end

      # The badge's id
      # @return [String]
      def id
        response["id"]
      end

      # Canonical id of the badge
      # @return [String]
      def badge_id
        response["badgeId"]
      end

      # The name of the badge
      # @return [String]
      def name
        response["name"]
      end

      # The message to be shown when user unlocks the badge
      # @return [String]
      def unlock_message
        response["unlockMessage"]
      end

      # The badge description
      # @return [String]
      def description
        response["description"]
      end

      # Text for the badge
      # @return [String]
      def badge_text
        response["badgeText"]
      end

      # Hint about the badge
      # @return [String]
      def hint
        response["hint"]
      end

      # The badge image details
      # @return [Hash]
      def image
        response["image"]
      end

      # An array of unlock data
      # @return [Array]
      def unlocks
        @unlocks = response["unlocks"]
        if @unlocks
          @unlocks.each do |unlock|
            if unlock["checkins"]
              unlock["checkins"] = unlock["checkins"].collect{|checkin| Foursquared::Response::Checkin.new(client, checkin)}
            end
          end
        end
      end
      
    end
  end
end