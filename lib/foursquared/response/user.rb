module Foursquared
  module Response
    class User
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :relationship, :gender, :contact, :bio, :type, :pings].each do |method_name|
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

      def pings
        response["pings"]
      end

      def photo
        Foursquared::Response::Photo.new(response[:photo])
      end

      def friends
        @friends = []
        if response["friends"] and response["friends"]["groups"]
          response["friends"]["groups"].each do |group|
            group["items"] = group["items"].collect{|friend| Foursquared::Response::User.new(client, friend)}
            @friends << group
          end
        end
      end

      def lists
        @lists = []
        if response["lists"] and response["lists"]["groups"]
          response["lists"]["groups"].each do |group|
            group["items"] = group["items"].collect{|list| Foursquared::Response::List.new(client, list)}
            @lists << group
          end
        end
        @lists
      end

    end

  end

end