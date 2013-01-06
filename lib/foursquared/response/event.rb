module Foursquared
  module Response
    # Event response
    class Event
      attr_reader :client, :response
      def initialize client, response
        @client  = client
        @response = response
      end

      [:id, :name, :url, :stats].each do |method_name|
        define_method method_name do
          response[method_name.to_s] if response
        end
      end

      [:venueId, :foreignIds, :categories, :allDay, :timeZone, :unlockMessage].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s] if response[method_name.to_s]
        end
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