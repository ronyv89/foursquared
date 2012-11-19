module Foursquared
  module Response
    class User
      attr_reader :response
      def initialize response
        @response = response
      end

      [:id, :relationship, :gender, :contact, :bio, :type].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      [:firstName, :lastName, :homeCity].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s]
        end
      end

      def name
        [first_name, last_name].join(' ').strip
      end

      def home_city
        response["homeCity"]
      end

      def pings
        fetch unless response.has_key?("pings")
        response["pings"]
      end

      def photo
        Foursquared::Response::Photo.new(response[:photo])
      end

      def friends
        @friends = []
        response["friends"]["groups"].each do |group|
          group["items"] = group["items"].collect{|friend| Foursquared::Response::User.new(friend)}
          @friends << group
        end
        @friends
      end

    end
  end

end