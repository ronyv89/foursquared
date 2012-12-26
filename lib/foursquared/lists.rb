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

  end
end
