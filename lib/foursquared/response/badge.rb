module Foursquared
  module Response
    # Badge response
    class Badge
      attr_reader :client, :response
      def initialize client, response
        @client  = client
        @response = response
      end

      [:id, :name, :description, :image, :hint].each do |method_name|
        define_method method_name do
          response[method_name.to_s] if response
        end
      end

      [:badgeId, :unlockMessage, :badgeText].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s] if response
        end
      end

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