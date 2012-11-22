module Foursquared
  module Response
    class BadgeGroup
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      [:type, :name, :image, :items].each do |method_name|
        define_method method_name do
          response["badge"][method_name.to_s] if response["badge"]
        end
      end
    end
  end
end