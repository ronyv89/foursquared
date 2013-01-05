module Foursquared
  module Response
    # List response
    class List
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      # Id of the list
      # @return [String]
      def id
        response["id"]
      end

      # Name of the list
      # @return [String]
      def name
        response["name"]
      end

      # The list description
      # @return [String]
      def description
        response["description"]
      end

      # The type of list
      # @return [String]
      def type
        response["type"]
      end

      # Whether the list is editable by the acting user
      # @return [Boolean]
      def editable?
        response["editable"]
      end

      # Whether the list is public
      # @return [Boolean]
      def public?
        response["public"]
      end

      # Whether this list is editable by the owner's friends
      # @return [Boolean]
      def collaborative?
        response["collaborative"]
      end

      # The list url
      # @return [String]
      def url
        response["url"]
      end

      # Whether the acting user is following this list
      # @return [Boolean]
      def following?
        response["following"]
      end

      # The canonical URL for this list
      # @return [String]
      def canonical_url
        response["canonicalUrl"]
      end

      # The number of venues on the list visited by the acting user
      # @return [Integer]
      def visited_count
        response["visitedCount"]
      end

      # The number of unique venues on the list.
      # @return [Integer]
      def venue_count
        response["venueCount"]
      end

      # The time at which the list was created
      # @return [Time]
      def created_at
        Time.at(response["createdAt"]) if response["createdAt"]
      end

      # The time at which the list was last updated
      # @return [Time]
      def updated_at
        Time.at(response["updatedAt"]) if response["updatedAt"]
      end

      # The user who created the list
      # @return [Foursquared::Response::User]
      def user
        Foursquared::Response::User.new(client, response["user"]) if response["user"]
      end

      # Photo for the list
      # @return [Foursquared::Response::Photo]
      def photo
        Foursquared::Response::Photo.new(client, response["photo"]) if response["photo"]
      end

      # Count and items of list items on this list.
      # @return [Hash]
      def list_items
        @list_items = response["listItems"]
        if @list_items and @list_items["items"]
          @list_items["items"].map!{|item| Foursquared::Response::ListItem.new(client, item)}
        end
        @list_items
      end

      # Suggests photos that may be appropriate for this item. 
      # @param [Hash] options
      # @option options [String] :itemId required, The ID of the list item
      # @return [Hash] Groups user and others containing lists (a count and items of photos) of photos uploaded by this user and uploaded by other users.
      def suggest_photo options={}
        @photos = client.get("/lists/#{id}/suggestphoto", options)["response"]["photos"]
        if @photos
          @photos.each_key do |key|
            key["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
          end
        end
        @photos
      end
      # Suggests venues that may be appropriate for this list.
      # @return [Array] Compact venues that may be appropriate for this list.
      def suggest_venues
        @suggested_venues = client.get("/lists/#{id}/suggestvenues")["response"]["suggestedVenues"]
        @suggested_venues.each do |item|
          item["venue"] = Foursquared::Response::Venue.new(client, item["venue"])
        end
        @suggested_venues
      end

      # Suggests tips that may be appropriate for a list item
      # @param [Hash] options
      # @option options [String] :itemId required, The ID of the list item
      def suggest_tip options={}
        @tips = client.get("/lists/#{id}/suggesttip", options)["response"]["tips"]
        if @tips
          @tips.each_key do |key|
            key["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
          end
        end
        @tips
      end

      # Add an Item to the list
      # @param [Hash] options
      # @option options [String] :venueId A venue to add to the list
      # @option options [String] :text If the target is a user-created list, this will create a public tip on the venue. If the target is /userid/todos, the text will be a private note that is only visible to the author.
      # @option options [String] :url  If adding a new tip via text, this can associate a url with the tip.
      # @option options [String] :tipId Used to add a tip to a list. Cannot be used in conjunction with the text and url fields.
      # @option options [String] :tipId Used to add a tip to a list. Cannot be used in conjunction with the text and url fields.
      # @option options [String] :listId Used in conjuction with itemId, the id for a user created or followed list as well as one of USER_ID/tips, USER_ID/todos, or USER_ID/dones.
      # @option options [String] :itemId Used in conjuction with listId, the id of an item on that list that we wish to copy to this list.
      # @return [Foursquared::Response::ListItem] The newly added list item
      def add_item options={}
        @item = client.post("/lists/#{id}/additem", options)["response"]["item"]
        Foursquared::Response::ListItem.new(client, @item) if @item
      end

      # List Followers
      # @return [Hash] A count and items of users following this list.
      def followers
        @followers = client.get("/lists/#{id}/followers")["response"]["followers"]
        if @followers and @followers["items"]
          @followers["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        @followers
      end

      # Delete an item from the list
      # @param [Hash] options
      # @option options [String] :venueId ID of a venue to be deleted.
      # @option options [String] :itemId ID of the item to delete.
      # @option options [String] :tipId id of a tip to be deleted.
      # @return [Hash] A count and items of list items that were just deleted.
      def delete_item options={}
        @items = client.post("/lists/#{id}/deleteitem", options)["response"]["items"]
        @items["items"].map!{|item| Foursquared::Response::ListItem.new(client, item)}
        @list_items
      end

      # Count and items of users who have edited this list
      # @return [Hash]
      def collaborators
        @collaborators = response["collaborators"]
        @collaborators["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        @collaborators
      end
    end
  end
end