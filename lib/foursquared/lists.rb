module Foursquared
  # Lists module
  module Lists
    # Gives details about a list.
    # @param [String] list_id required, ID for a list
    # @param [Hash] options
    # @option options [Integer] :limit Number of results to return, up to 200.
    # @option options [Integer] :offset The number of results to skip
    # @option options [String] :llBounds Restricts the returned results to the input bounding box.
    # @option options [String] :categoryId Restricts the returned results to venues matching the input category id.
    # @return [Foursquared::Response::List]
    def list list_id, options={}
      response = get("/lists/#{list_id}", options)["response"]
      @list = Foursquared::Response::List.new(self, response["list"])
    end

    # Add a List
    # @param [Hash] options
    # @option options [String] :name required, The name of the list.
    # @option options [String] :description The description of the list.
    # @option options [Boolean] :collaborative Boolean indicating if this list can be edited by friends.
    # @option options [String] :photoId The id of a photo that should be set as the list photo.
    # @return [Foursquared::Response::List] The added list
    def add_list options={}
      response = post("/lists/add", options)["response"]
      Foursquared::Response::List.new(self, response["list"])
    end

    # Suggests photos that may be appropriate for a list item. 
    # @param [String] list_id required, ID for a list
    # @param [Hash] options
    # @option options [String] :itemId required, The ID of the list item
    # @return [Hash] Groups user and others containing lists (a count and items of photos) of photos uploaded by this user and uploaded by other users.
    def suggest_list_photo list_id, options={}
      @photos = get("/lists/#{list_id}/suggestphoto", options)["response"]["photos"]
      if @photos
        @photos.each_key do |key|
          key["items"] = key["items"].collect{|photo| Foursquared::Response::Photo.new(client, photo)}
        end
      end
      @photos
    end

    # Suggests venues that may be appropriate for a list.
    # @param [String] list_id required, ID for a list
    # @return [Array] Compact venues that may be appropriate for this list.
    def suggest_list_venues list_id
      @suggested_venues = get("/lists/#{list_id}/suggestvenues")["response"]["suggestedVenues"]
      @suggested_venues.each do |item|
        item["venue"] = Foursquared::Response::Venue.new(self, item["venue"])
      end
      @suggested_venues
    end

    # Suggests tips that may be appropriate for a list item
    # @param [String] list_id required, ID for a list
    # @param [Hash] options
    # @option options [String] :itemId required, The ID of the list item
    def suggest_list_tip list_id, options={}
      @tips = get("/lists/#{list_id}/suggesttip", options)["response"]["tips"]
      if @tips
        @tips.each_key do |key|
          key["items"].map!{|item| Foursquared::Response::Photo.new(client, item)}
        end
      end
      @tips
    end

    # Add an Item to a list
    # @param [String] list_id required, ID for a list
    # @param [Hash] options
    # @option options [String] :venueId A venue to add to the list
    # @option options [String] :text If the target is a user-created list, this will create a public tip on the venue. If the target is /userid/todos, the text will be a private note that is only visible to the author.
    # @option options [String] :url  If adding a new tip via text, this can associate a url with the tip.
    # @option options [String] :tipId Used to add a tip to a list. Cannot be used in conjunction with the text and url fields.
    # @option options [String] :listId Used in conjuction with itemId, the id for a user created or followed list as well as one of USER_ID/tips, USER_ID/todos, or USER_ID/dones.
    # @option options [String] :itemId Used in conjuction with listId, the id of an item on that list that we wish to copy to this list.
    # @return [Foursquared::Response::ListItem] The newly added list item
    def add_list_item list_id, options={}
      @item = post("/lists/#{list_id}/additem", options)["response"]["item"]
      Foursquared::Response::ListItem.new(client, @item) if @item
    end

    # Delete an item from the list
    # @param [String] list_id required, ID for a list
    # @param [Hash] options
    # @option options [String] :venueId ID of a venue to be deleted.
    # @option options [String] :itemId ID of the item to delete.
    # @option options [String] :tipId id of a tip to be deleted.
    # @return [Hash] A count and items of list items that were just deleted.
    def delete_list_item list_id, options={}
      @items = client.post("/lists/#{list_id}/deleteitem", options)["response"]["items"]
      @items["items"].map!{|item| Foursquared::Response::ListItem.new(client, item)}
      @list_items
    end
  end
end
