module Foursquared
  module Response
    class ListItem
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      def id
        response["id"]
      end

      [:user, :photo, :venue, :tip].each do |method_name|
        define_method method_name do
          Foursquared::Response.const_get(method_name.to_s.capitalize).new(client, response[method_name.to_s])
        end
      end

    end
  end
end