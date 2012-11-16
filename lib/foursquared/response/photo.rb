module Foursquared
  module Response
    class Photo
      attr_reader :response
      def initialize(response)
        @response = response
      end

      [:id, :prefix, :suffix, :source, :width, :height, :visibility].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      def created_at
        response["createdAt"]
      end

      def user
        Foursquared::Response::User.new(response["user"]) if response["user"]
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