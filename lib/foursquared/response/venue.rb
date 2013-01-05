module Foursquared
  module Response
    # Venue response
    class Venue
      attr_reader :client, :response

      def initialize client, response
        @client = client
        @response = response
      end

      # The venue ID
      # @return [String]
      def id
        response["id"]
      end

      # The venue name
      # @return [String]
      def name
        response["name"]
      end

      # The contact details for the venue
      # @return [Hash]
      def contact
        response["contact"]
      end

      # The location details for the venue
      # @return [Hash]
      def location
        response["location"]
      end

      # Whether this is a verified venue
      # @return [Boolean]
      def verified?
        response["verified"]
      end

      # The canonical url for this venue
      # @return [String]
      def canonical_url
        response["canonicalUrl"]
      end

      # An array of categories that have been applied to this venue
      # @return [Array<Foursquared::Response::Category>]
      def categories
        response["categories"].map!{|category| Foursquared::Response::Category.new(client, category)} if response["categories"]
      end

      # Contains checkinsCount , usersCount , and tipCount.
      # @return [Hash]
      def stats
        response["stats"]
      end

      # URL of the venue's website, typically provided by the venue manager.
      def url
        response["url"]
      end

      # An object containing the price tier from 1 (least pricey) - 4 (most pricey) and a message describing the price tier.
      # @return [Hash]
      def price
        response["price"]
      end

      # Whether the current user has liked this venue.
      # @return [Boolean]
      def like?
        response["like"]
      end

      # Whether the current user has disliked this venue.
      # @return [Boolean]
      def dislike?
        response["dislike"]
      end

      # The rating for this venue
      # @return [Float]
      def rating
        response["rating"]
      end

      # Array of categories that have been applied to this venue
      # @return [Array<Foursquared::Response::Category>]
      def categories
        @categories = response["categories"] || []
        @categories.map!{|category| Foursquared::Response::Category.new(client, category)}
      end

      # Menu information for the venue.
      # @return [Hash]
      def menu
        response["menu"]
      end

      # Contains the hours during the week that the venue is open along with any named hours segments in a human-readable format.
      # @return [Hash]
      def hours
        response["hours"]
      end

      # An array of phrases applied to this menu
      # @return [Array<Hash>]
      def phrases
        response["phrases"]
      end

      # Count and items of reasons that have been applied at this venue
      # @return [Hash]
      def reasons
        response["reasons"]
      end

      # Venue description
      # @return [String]
      def description
        response["description"]
      end

      # The mayor of the venue
      # @return [Foursquared::Response::User]
      def mayor
        Foursquared::Response::User.new(response["mayor"]["user"]) if response["mayor"] and response["mayor"]["user"]
      end

      # Users who like the venue
      # @return [Hash]
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

      # Count and items of specials at the venue
      # @return [Hash]
      def specials
        @specials = response["specials"]
        @specials["items"].map!{|item| Foursquared::Response::Special.new(client, item)} if @specials
        @specials
      end

      # The time at which the venue was added
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # The tips for this venue
      # @return [Hash]
      def tips
        @tips = response["tips"]
        if @tips["groups"]
          @tips["groups"].each do |group|
            group["items"].map!{|item| Foursquared::Response::Tip.new(client, item)}
          end
        end
        @tips
      end

      # Array of string tags for this venue
      # @return [Array<String>]
      def tags
        response["tags"]
      end

      # The shortened url for the venue
      # @return [String]
      def short_url
        response["shortUrl"]
      end

      # The time zone
      # @return [String]
      def time_zone
        response["timeZone"]
      end

      # A grouped response of lists that contain this venue
      # @return [Hash]
      def listed
        @listed = response["listed"]
        @listed["groups"].each do |group|
          @listed["items"].map!{|item| Foursquared::Response::List.new(client, item)}
        end
        @listed
      end

      # The number of times the acting user has been to this venue
      # @return [Integer]
      def been_here
        response["beenHere"]["count"] if response["beenHere"]
      end

      # Present only for venues returned in Explore search results.
      # @return [Hash]
      def flags
        response["flags"]
      end

      # Present if and only if the current user has at least one assigned role for this venue.
      # @return [Array]
      def roles
        response["roles"]
      end

      # The venue photos
      # @return [Hash] count and groups of photos
      def photos
        @photos = response["photos"]
        if @photos
          @photos["groups"].each do |group|
            group["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
          end
        end
        @photos
      end

      # The users who have checked in here now
      # @return [Hash] count and groups of users
      def here_now
        @here_now = response["hereNow"]
        if @here_now
          @here_now["groups"].each do |group|
            group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
          end
        end
        @here_now
      end

      # Specials available at nearby venues
      # @return [Array<Foursquared::Response::Special>]
      def specials_nearby
        response["specialsNearby"].map{|special| Foursquared::Response::Special.new(client, special)} if response["specialsNearby"]
      end

    end
  end
end