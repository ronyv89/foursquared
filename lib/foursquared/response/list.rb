module Foursquared
  module Response
    class List
      attr_reader :response
      def initialize response
        @response = response
      end

      [:id, :name, :description, :type, :editable, :public, :collaborative, :url, :following].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      [:canonicalUrl, :createdAt, :updatedAt, :visitedCount, :venueCount].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s]
        end
      end

      def user
        Foursquared::Response::User.new(response["user"])
      end

      def photo
        Foursquared::Response::Photo.new(response["photo"])
      end

      def followers
        @followers = []
        if response["followers"] and response["followers"]["items"]
          response["followers"]["items"].each do |follower|
          @followers << Foursquared::Response::User.new(follower) 
          end
        end
        @followers
      end

      def collaborators
        response["collaborators"]["items"].collect{|collaborator| Foursquared::Response::User.new(collaborator)}
      end
    end
  end
end         