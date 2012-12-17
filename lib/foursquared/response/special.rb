module Foursquared
  module Response
    class Special
      attr_reader :client, :response

      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :description, :type, :message, :unlocked, :icon, :title, :state, :progress, :target, :provider, :redemption].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      [:progressDescription, :imageUrls].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s]
        end
      end

      def friends_here
        @friends = response["friendsHere"].collect{|friend| Foursquared::Response::User(client, friend)}
      end
    end
  end
end