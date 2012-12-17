module Foursquared
  module Response
    class Category
      attr_reader :response
      def initialize response
        @response = response
      end

      def id
        response["id"]
      end

      def name
        response["name"]
      end

      def plural_name
        response["pluralName"]
      end

      def short_name
        response["shortName"]
      end

      def icon
        @icon = response["icon"]
        @icon["urls"] = {
          "32x32" => "#{@icon["prefix"].chomp("_")}#{@icon["suffix"]}",
          "64x64" => "#{@icon["prefix"]}_64#{@icon["suffix"]}",
          "256x256" => "#{@icon["prefix"]}_256#{@icon["suffix"]}",
        }
        @icon
      end
      def categories
        response["categories"].map!{|category| Foursquared::Response::Category.new(category)}
      end
    end
  end
end
