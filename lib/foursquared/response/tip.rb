module Foursquared
  module Response
    # Tip response class
    class Tip
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      # ID of the tip
      # @return [String] tip id
      def id
        response["id"]
      end

      # Time since creation of the tip
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # The actual tip
      # @return [String]
      def text
        response["text"]
      end

      # The canonical url for the tip
      # @return [String] url
      def canonical_url
        response["canonicalUrl"]
      end

      # Groups of users who like the tip
      # @return [Hash] count, groups and summary
      def likes
        @likes = response["likes"] 
        @likes["groups"].each{ |group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @likes and @likes["groups"]
      end

      # Whether the acting user likes the tip
      # @return [Boolean] true or false
      def like?
        response["like"] || false
      end

      # If the context allows tips from multiple venues, the compact venue for this tip. 
      # @return [Foursquared::Response::Venue]
      def venue
        Foursquared::Response::Venue.new(client, response["venue"]) if response["venue"]
      end

      # If the context allows tips from multiple venues, the compact venue for this tip. 
      # @return [Foursquared::Response::User]
      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      # Groups of lists
      # @return [Hash] count and groups of lists
      def listed
        @listed = response["listed"]

        @listed["groups"].each{|group| group["items"].map!{|item| Foursquared::Response::List.new(client, item)}} if @listed and @listed["groups"]
      end

      # Photo for this tip
      # @return [Foursquared::Response::Photo]
      def photo
        Foursquared::Response::Photo.new(client, response["photo"]) if response["photo"]
      end

      # Status of this tip.
      # @return [String] todo or done
      def status
        response["status"]
      end

      # A URL for more information. 
      # @return [String]
      def url
        response["url"]
      end

      # Users who have marked this tip todo
      # @return [Hash] count and groups of users
      def todo
        @todo = response["todo"]
        @todo["groups"].each {|group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @todo and @todo["groups"]
      end

      # Users who have done this tip todo
      # @return [Hash] count and groups of users
      def done 
        @done = response["done"]
        @done["groups"].each {|group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @done and @done["groups"]
      end


    end
  end
end