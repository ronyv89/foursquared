module Foursquared
  module Response
    # Photo response
    class Photo
      attr_reader :client, :response
      def initialize(client, response)
        @client = client
        @response = response
      end

      [:id, :prefix, :suffix, :source, :width, :height, :visibility].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      # The ID of the photo
      # @return [String]
      def id
        response["id"]
      end

      # The time at which the photo was created
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # The name and url for the application that created this photo.
      def source
        response["source"]
      end

      # Start of the URL for this photo.
      # @return [String]
      def prefix
        response["prefix"]
      end

      # End of the URL for this photo.
      # @return [String]
      def suffix
        response["suffix"]
      end

      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      def urls
        @urls = {
          "36x36" => url(36,36),
          "100x100" => url(100,100),
          "300x300" => url(300,300),
          "500x500" => url(500,500)
        }
        @urls.merge!({"original" => url(width, height)}) if (width and height)
      end

      private
      def url width, height
        "#{prefix}#{width}x#{height}#{suffix}"
      end
    end
  end
end

