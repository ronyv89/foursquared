module Foursquared
  # Tips module
  module Tips
    # Tip detail 
    # @param [String] tip_id required, ID of tip to retrieve.
    # @return [Foursquared::Response::Tip] A complete tip.
    def tip tip_id
      response = get("/tips/#{tip_id}")["response"]
      Foursquared::Response::Tip.new(self, response["tip"])
    end

    # Add a tip 
    # @param [Hash] options
    # @option options [String] :venueId required, the venue where you want to add this tip.
    # @option options [String] :text required, the text of the tip, up to 200 characters.
    # @option options [String] :url A URL related to this tip.
    # @option options [String] :broadcast eg: twitter,facebook
    # @return [Foursquared::Response::Tip] The newly added tip
    def add_tip options={}
      response = post("/tips/add", options)["response"]
      Foursquared::Response::Tip.new(self, response["tip"])
    end

    # Search Nearby Tips 
    # @param [Hash] options
    # @option options [String] :ll required, unless near is provided. Latitude and longitude of the user's location.
    # @option options [String] :near required, unless ll is provided. A string naming a place in the world
    # @option options [Integer] :limit optional, number of results to return, up to 500.
    # @option options [Integer] :offset optional, used to page through results.
    # @option options [String] :filter if set to friends, only show nearby tips from friends.
    # @option options [String] :query only find tips matching the given term, cannot be used in conjunction with friends filter.
    # @return [Array] tips matching the criteria
    def search_tips options={}
      response = get("/tips/search", options)["response"]
      @tips = response["tips"]
      @tips.collect{|tip| Foursquared::Response::Tip.new(self, tip)}
    end

    # Users who have done a tip
    # @param [String] tip_id required, ID of tip.
    # @param [Hash] options
    # @option options [Integer] :limit optional, number of results to return, up to 200.
    # @option options [Integer] :offset optional, used to page through results.
    # @return A count and items of compact user objects
    def tip_dones tip_id, options={}
      response = get("/tips/#{tip_id}/done", options)["response"]
      @users = response["users"]
      @users["items"].map!{|item| Foursquared::Response::User.new(self, item)} if @users["items"]
      @users
    end

    # Users who have liked a tip
    # @param [String] tip_id required, ID of tip.
    # @return [Hash] A count and groups of users who like this tip
    def tip_likes tip_id
      response = get("/tips/#{tip_id}/likes")["response"]
      @likes = response["likes"]
      @likes["groups"].each{ |group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @likes and @likes["groups"]
    end

    # The lists that this tip appears on 
    # @param [String] tip_id required, ID of tip.
    # @return [Hash]
    def tip_listed tip_id, options={}
      response = get("/tips/#{tip_id}/listed")["response"]
      @lists = response["lists"]
      if @lists["groups"]
        @lists["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::List.new(client, item) } if group["items"]
        end
      elsif @lists["items"]
        @lists["items"].map!{|item| Foursquared::Response::List.new(client, item) }
      end
    end

    # Like or unlike a tip 
    # @param [String] tip_id required, ID of tip.
    # @param [Hash] options
    # @option options [Integer] :set If 1, like this tip. If 0 unlike (un-do a previous like) it. Default value is 1
    # @return [Hash] Updated count and groups of users who like this tip.
    def like_tip tip_id, options={}
      response = post("/tips/#{tip_id}/like", options)["response"]
      @likes = response["likes"]
      @likes["groups"].each{ |group| group["items"].map!{|item| Foursquared::Response::User.new(client, item)}} if @likes and @likes["groups"]
    end

    # Mark a tip done 
    # @param [String] tip_id required, ID of tip.
    # @return [Foursquared::Response::Tip] The marked to-do.
    def mark_tip_done tip_id
      response = post("/tips/#{tip_id}/markdone")["response"]
      Foursquared::Response::Tip.new(self, response["tip"])
    end

    # Mark a tip to-do
    # @param [String] tip_id required, ID of tip.
    # @return [Foursquared::Response::Todo] The marked to-do.
    def mark_tip_todo tip_id
      response = post("/tips/#{tip_id}/marktodo")["response"]
      Foursquared::Response::Todo.new(self, response["todo"])
    end

    # Unmark a tip as to-do 
    # @param [String] tip_id required, ID of tip.
    # @return [Foursquared::Response::Tip] The marked to-do.
    def unmark_tip_todo tip_id
      response = post("/tips/#{tip_id}/unmark")["response"]
      Foursquared::Response::Tip.new(self, response["tip"])
    end

  end
end