# Foursquared Module
module Foursquared
  # Users module
  module Users

    # Return profile information for a given user
    # @param [String, Integer] user_id user's id
    # @return [Foursquared::Response::User] A user.
    def user user_id="self"
      @user = get("/users/#{user_id}")["response"]["user"]
      Foursquared::Response::User.new(self,@user)
    end

    # Returns the user's leaderboard.
    # @param [Hash] options the optional options to be passed with the request
    # @option options [Integer] :neighbors Number of friends' scores to return that are adjacent to your score, in ranked order.
    # @return [Hash] the user's leaderboard.
    def leaderboard options={}
      @leaderboard = get("/users/leaderboard", options)["response"]["leaderboard"]
      @leaderboard["items"].each do |item|
        item["user"] = Foursquared::Response::User.new(self,item["user"])
      end
      @leaderboard
    end

    # Approves a pending friend request from another user.
    # @param [String, Integer] user_id The request user's id
    # @return [Foursquared::Response::User] the approved user
    def approve_friend_request user_id
      response = post("/users/#{user_id}/approve")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    # Denies a pending friend request from another user.
    # @param [String, Integer] user_id The request user's id
    # @return [Foursquared::Response::User] the denied user
    def deny_friend_request user_id
      response = post("/users/#{user_id}/deny")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    # Send a Friend/Follow Request
    # @param [String, Integer] user_id The request user's/page's id
    # @return [Foursquared::Response::User] the pending user
    def send_friend_request user_id
      response = post("/users/#{user_id}/request")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    # Removes a friend, unfollows a celebrity, or cancels a pending friend request.
    # @param [String, Integer] user_id The request user's id
    # @return [Foursquared::Response::User] the removed user
    def unfriend user_id
      response = post("/users/#{user_id}/unfriend")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    # Pending friend requests
    # @return [Array] User objects
    def requests
      response = get("/users/requests")["response"]
      @requests = response["requests"].collect{|request| Foursquared::Response::User.new(self,request)}
    end

    # Find users
    # @param [Hash] options
    # @option options [String] :phone A comma-delimited list of phone numbers to look for.
    # @option options [String] :email A comma-delimited list of email addresses to look for.
    # @option options [String] :twitter A comma-delimited list of Twitter handles to look for.
    # @option options [String] :twitterSource A single Twitter handle. Results will be users that this handle follows on Twitter who use Foursquare.
    # @option options [String] :fbid A comma-delimited list of Facebook ID's to look for.
    # @option options [String] :name A single string to search for in users' names.
    # @return [Hash]
    def search options={}
      response = get("/users/search", options)["response"]
      response["results"].map!{|result| Foursquared::Response::User.new(self,result)}
      response
    end

    # Set whether to receive pings about a user
    # @param [String, Integer] user_id User ID of a friend
    # @param [Hash] options
    # @option options [Boolean] :value True or false.
    # @return [Foursquared::Response::User] User object for the user
    def set_pings user_id, options={}
      response = post("/users/#{user_id}/setpings", options)["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    # Update user's photo
    # @param [String] image_filename The location of the photo to be uploaded
    # @return [Foursquared::Response::User] User object for the user
    def update_photo image_filename
      response = post("/users/self/update", options={:photo => File.read(image_filename)})["response"]
      @user = Foursquared::Response::User.new(self, response["user"])
    end

    # Checkins by a user
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options [Integer] :limit Number of results to return, up to 250.
    # @option options [Integer] :offset The number of results to skip. Used to page through results.
    # @option options [String] :sort How to sort the returned checkins. Can be "newestfirst" or "oldestfirst".
    # @option options [Integer] :afterTimestamp Retrieve the first results to follow these seconds since epoch
    # @option options [Integer] :beforeTimestamp Retrieve the first results prior to these seconds since epoch
    # @return [Hash] A count and items of check-ins.
    def user_checkins user_id="self", options={}
      response = get("/users/#{user_id}/checkins",options)["response"]["checkins"]
      response["items"].map!{|checkin| Foursquared::Response::Checkin.new(self, checkin)} if response["items"]
      response
    end

    # List friends
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options [Integer] :limit Number of results to return, up to 500.
    # @option options [Integer] :offset Used to page through results.
    # @return [Hash]  A count and items of friends.
    def user_friends user_id="self", options={}
      response = get("/users/#{user_id}/friends"), options["response"]["friends"]
      response["items"].map!{|friend| Foursquared::Response::User.new(self, friend)} if response["items"]
      response
    end

    # Return the user's lists
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options [String] :group "edited", "created", "followed", "friends" or "suggested"
    # @option options [String] :ll Location of the user eg: 40.7,-74
    # @return [Hash]
    def user_lists user_id="self", options={}
      response = get("/users/#{user_id}/lists", options)["response"]
      @lists = response["lists"]
      @lists["groups"].each do |group|
        group["items"].map!{|item| Foursquared::Response::List.new(self, item)}
      end
      @lists
    end

    # List user's mayorships
    # @param [String, Integer] user_id
    # @return [Hash]
    def user_mayorships user_id="self"
      response = get("/users/#{user_id}/mayorships")["response"]
      @mayorships = response["mayorships"]
      @mayorships["items"].each{|item| item["venue"] = Foursquared::Response::Venue.new(self, item["venue"])}
      @mayorships
    end

    # Photos from a User
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options [Integer] :limit Number of results to return, up to 500.
    # @option options [Integer] :offset The number of results to skip. Used to page through results.
    # @return [Hash] A count and items of photos.
    def user_photos user_id="self", options={}
      response = get("/users/#{user_id}/photos",options)["response"]
      @photos = response["photos"]
      @photos["items"].map!{|item| Foursquared::Response::Photo.new(self, item)}
    end

    # Tips from a User
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options :limit Number of results to return, up to 200.
    # @option options :offset The number of results to skip. Used to page through results.
    # @option options :llBounds Restricts the returned results to the input bounding box.
    # @option options :categoryId Restricts the returned results to venues matching the input category id.
    # @return [Foursquared::Response::List]
    def user_tips user_id="self", options={}
      response = get("/lists/#{user_id}/tips", options)["response"]
      Foursquared::Response::List.new(self, response["list"])
    end

    # Todos from a User
    # @param [String, Integer] user_id
    # @param [Hash] options
    # @option options :limit Number of results to return, up to 200.
    # @option options :offset The number of results to skip. Used to page through results.
    # @option options :llBounds Restricts the returned results to the input bounding box.
    # @option options :categoryId Restricts the returned results to venues matching the input category id.
    # @return [Foursquared::Response::List]
    def user_todos user_id="self", options={}
      response = get("/lists/#{user_id}/todos", options)["response"]
      Foursquared::Response::List.new(self, response["list"])
    end

    # Badges for a user
    # @param [String, Integer] user_id
    # @return [Hash]
    def user_badges user_id="self"
      response = get("/users/#{user_id}/badges")["response"]
      if response["sets"] and response["sets"]["groups"]
        response["sets"]["groups"].map!{|group| Foursquared::Response::BadgeGroup.new(self, group)}
      end

      if response["badges"]
        response["badges"].each_key do |badge_id|
          response["badges"][badge_id] = badge(badge_id)
        end
      end
      response
    end

  end
end