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
        response["like"]
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

      # Like or unlike the tip 
      # @param [Hash] options
      # @option options [Integer] :set If 1, like this tip. If 0 unlike (un-do a previous like) it. Default value is 1
      # @return [Hash] Updated count and groups of users who like this tip.
      def like options={}
        response = post("/tips/#{id}/like", options)["response"]
        @likes = response["likes"]
        @likes["groups"].each{ |group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @likes and @likes["groups"]
        @likes
      end

      # Mark the tip done 
      # @return [Foursquared::Response::Tip] The marked to-do.
      def mark_done 
        response = post("/tips/#{id}/markdone")["response"]
        Foursquared::Response::Tip.new(self, response["tip"])
      end

      # Mark the tip to-do
      # @return [Foursquared::Response::Todo] The marked to-do.
      def mark_todo
        response = post("/tips/#{id}/marktodo")["response"]
        Foursquared::Response::Todo.new(self, response["todo"])
      end

      # Unmark the tip as to-do 
      # @return [Foursquared::Response::Tip] The current tip
      def unmark_todo tip_id
        response = post("/tips/#{tip_id}/unmark")["response"]
        Foursquared::Response::Tip.new(self, response["tip"])
      end
      
    end
  end
end