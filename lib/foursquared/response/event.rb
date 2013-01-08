module Foursquared
  module Response
    # Event response
    class Event
      attr_reader :client, :response
      
      def initialize client, response
        @client  = client
        @response = response
      end


      # The ID of the event
      # @return [String]
      def id
        response["id"]
      end

      # The name of the event
      # @return [String]
      def name
        response["name"]
      end

      # The website for the event
      # @return [String]
      def url
        response["url"]
      end

      # The stats for the event
      # @return [String]
      def stats
        response["stats"]
      end

      # The ID of the venue of the event
      # @return [String]
      def venue_id
        response["venueId"]
      end

      # The count of ids of this event in third-party services, plus items, an array of domain, the third party provider, and id, the id in their system. 
      # @return [Hash]
      def foreign_ids
        response["foreignIds"]
      end

      # The categories that have been applied to this event
      # @return [Array<Foursquared::Response::Category>]
      def categories
        @categories = response["categories"]
        @categories.map!{|category| Foursquared::Response::Category.new(client, category)} if @categories
        @categories
      end

      # Whether the event happens throughout the day
      # @return [Boolean]
      def all_day?
        response["allDay"]
      end

      # The time zone for the event 
      # @return [String]
      def time_zone
        response["timeZone"]
      end

      # The unlock message for the checkin at the event
      # @return [String]
      def unlock_message
        response["unlockMessage"]
      end

      # The time at which the event starts
      # @return [Time]
      def start_at
        Time.at response["startAt"] if response["startAt"]
      end

      # The time at which the event ends
      # @return [Time]
      def end_at
        Time.at response["endAt"] if response["endAt"]
      end

      # The date at which the event is happening
      # @return [Time]
      def date
        Time.at response["date"] if response["date"]
      end

      # Users who are present at the event now
      # @return [Hash]
      def here_now
        @here_now = response["hereNow"]
        @here_now["groups"].each do |group| 
          group["items"].map!{|user| Foursquared::Response::User.new(client, user)}
        end
        @here_now
      end
    end
  end
end