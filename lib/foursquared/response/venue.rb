module Foursquared
  module Response
    class Venue
      attr_reader :client, :response

      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :name, :contact, :location, :verified, :stats, :url, :like, :dislike, :description, :rating, :phrases, :reasons].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      def mayor
        Foursquared::Response::User.new(response["mayor"]["user"]) if response["mayor"] and response["mayor"]["user"]
      end

      def likes
        likes_response = client.get("/venues/#{id}/likes")["response"]
        @likes = {}
        if likes_response["likes"]
          @likes.merge!(likes_response["likes"])
          if @likes["groups"]
            @likes["groups"].each do |group|
              group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
            end
          end
        end
        @likes
      end

    end
  end
end