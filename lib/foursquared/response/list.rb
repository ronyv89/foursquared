module Foursquared
  module Response
    class List
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :name, :description, :type, :editable, :public, :collaborative, :url, :following].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      [:canonicalUrl, :visitedCount, :venueCount].each do |method_name|
        define_method method_name.to_usym do
          response[method_name.to_s]
        end
      end

      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      def updated_at
        Time.at(response["updatedAt"]) if response["updatedAt"]
      end

      def user
        Foursquared::Response::User.new(client, response["user"])
      end

      def photo
        Foursquared::Response::Photo.new(client, response["photo"])
      end

      def followers
        @followers = []
        if response["followers"] and response["followers"]["items"]
          response["followers"]["items"].each do |follower|
          @followers << Foursquared::Response::User.new(client, follower)
          end
        end
        @followers
      end

      def collaborators
        response["collaborators"]["items"].collect{|collaborator| Foursquared::Response::User.new(client, collaborator)}
      end
    end
  end
end