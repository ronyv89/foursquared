module Foursquared
  module Response
    # Category object
    class Category
      attr_reader :response
      def initialize response
        @response = response
      end

      # Return the id of the category
      # @return [String]
      def id
        response["id"]
      end

      # Return the name of the category
      # @return [String]
      def name
        response["name"]
      end

      # Return the plural name of the category
      # @return [String]
      def plural_name
        response["pluralName"]
      end

      # Return the short name of the category
      # @return [String]
      def short_name
        response["shortName"]
      end

      # Return the details for icons of the category
      # @return [Hash] with urls added for each icon size
      def icon
        @icon = response["icon"]
        @icon["urls"] = {
          "32x32" => "#{@icon["prefix"].chomp("_")}#{@icon["suffix"]}",
          "64x64" => "#{@icon["prefix"]}_64#{@icon["suffix"]}",
          "256x256" => "#{@icon["prefix"]}_256#{@icon["suffix"]}",
        }
        @icon
      end

      # The sub-categories for the category
      # @return [Array] array of sub-categories
      def categories
        response["categories"].map!{|category| Foursquared::Response::Category.new(category)}
      end
    end
  end
end
