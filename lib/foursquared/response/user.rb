# Foursquared module
module Foursquared
  # Response module
  module Response
    # User response class
    class User
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      # The user's id
      # @return [String] The user's id
      def id
        response["id"]
      end

      # User's first name
      # @return [String]
      def first_name
        response["firstName"]
      end

      # User's last name
      # @return [String]
      def last_name
        response["lastName"]
      end

      # User's full name
      # @return [String]
      def name
        [first_name, last_name].join(' ').strip
      end

      # User's profile photo
      # @return [Foursquared::Response::Photo]
      def photo
        Foursquared::Response::Photo.new(client, response["photo"])
      end

      # User's relationship with the acting user
      # @return [String]
      def relationship
        response["relationship"]
      end

      # User's friends list retrieved from the initial response
      # @return [Hash] count and groups of users
      def friends
        @friends = response["friends"]
        @friends["groups"].each do |group|
          group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
        end
        @friends
      end

      # User's full friends list 
      # @param [Hash] options
      # @option options [Integer] :limit Number of results to return, up to 500.
      # @option options [Integer] :offset Used to page through results.
      # @return [Hash]  A count and items of friends.
      def full_friends options={}
        client.user_friends(id, options)
      end

      # User's gender
      # @return [String]
      def gender
        response["gender"]
      end

      # User's home city
      # @return [String]
      def home_city
        response["homeCity"]
      end

      # A short bio for the user
      # @return [String]
      def bio
        response["bio"]
      end

      # Whether to ping if user checkins
      # @return [String]
      def checkin_pings
        response["checkinPings"]
      end

      # Whether we receive pings from this user, if we have a relationship.
      # @return [Boolean]
      def pings
        response["pings"]
      end

      # User's current game status.
      # @return [Hash] Contains recent, max, checkinsCount, and goal for showing user's current game status.
      def scores
        response["scores"]
      end

      # Type of user. Optional, Present for non-standard user types
      # @return [String] One of page, chain, celebrity, or venuePage
      def type
        response["type"]
      end

      # Venue details
      # @return [Foursquared::Response::Venue] Optional For venuePage users, this field just contains an id for the relevant venue.
      def venue
        Foursquared::Response::Venue.new(client, response["venue"]) if response["venue"]
      end

      # User's contact details
      # @return [Hash] An object containing none, some, or all of twitter, facebook, email, and phone.
      def contact
        response["contact"]
      end

      # Page details
      # @return [Hash] Optional, Contains a detailed page, if the type is a page. 
      def page_info
        response["pageInfo"]
      end

      # User's refferal ID
      # @return [String]
      def refferal_id
        response["refferalId"]
      end

      # User's followers
      # @return [Hash]  Optional, Contains count of followers and groups of users who follow or like this user
      def followers
        if response["followers"] and response["followers"]["groups"]
          @followers = response["followers"]
          @followers["groups"].each do |group|
             group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
          end
          return @followers
        end
      end

      # Groups of pages this user user has liked or followed.
      # @return [Hash]
      def following
        if response["following"] and response["following"]["groups"]
          @following = response["following"]
          @following["groups"].each do |group|
             group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
          end
          return @following
        end
      end

      # Return the user's lists
      # @return [Hash]
      def lists
        @lists = response["lists"]
        if @lists and @lists["groups"]
          @lists["groups"].each do |group|
            group["items"].map!{|item| Foursquared::Response::List.new(client, item)}
          end
        end
        @lists
      end

      # Return the user's full lists
      # @param [Hash] options
      # @option options [String] :group "edited", "created", "followed", "friends" or "suggested"
      # @option options [String] :ll Location of the user eg: 40.7,-74
      # @return [Hash]
      def full_lists options={}
        client.user_lists(id, options)
      end

      # List user's mayorships 
      # @return [Hash]
      def mayorships
        @mayorships = response["mayorships"]
        @mayorships["items"].each{|item| item["venue"] = Foursquared::Response::Venue.new(client, item["venue"])}
        @mayorships
      end

      # List user's full mayorships 
      # @return [Hash]
      def full_mayorships
        client.user_mayorships(id)
      end

      # List user's badges
      # @return [Hash] count and items of badges
      def badges
        @badges = response["badges"]
        @badges["items"].map!{|item| Foursquared::Response::Badge.new(client, item)}
      end

      # List user's full badges
      # @return [Hash]
      def full_badges
        client.user_badges(id)
      end
      
      # Approves a pending friend request from this user.
      # @return [Foursquared::Response::User] the approved user
      def approve_friend_request user_id
        response = post("/users/#{id}/approve")["response"]
        @user = Foursquared::Response::User.new(client, response["user"])
      end

      # Denies a pending friend request from this user.
      # @return [Foursquared::Response::User] the denied user
      def deny_friend_request
        request_response = post("/users/#{id}/deny")["response"]
        @user = Foursquared::Response::User.new(client, request_response["user"])
      end

      # Send a Friend/Follow Request to this user
      # @param [String, Integer] user_id The request user's/page's id
      # @return [Foursquared::Response::User] the pending user
      def send_friend_request
        request_response = post("/users/#{id}/request")["response"]
        @user = Foursquared::Response::User.new(client, request_response["userrequest_"])
      end

      # Removes a friend, unfollows a celebrity, or cancels a pending friend request. 
      # @return [Foursquared::Response::User] the removed user
      def unfriend
        request_response = post("/users/#{id}/unfriend")["response"]
        @user = Foursquared::Response::User.new(client, request_response["user"])
      end

      # Set whether to receive pings about this user 
      # @param [Hash] options
      # @option options [Boolean] :value required, true or false.
      # @return [Foursquared::Response::User] User object for the user
      def set_pings options={}
        request_response = post("/users/#{id}/setpings", options)["response"]
        @user = Foursquared::Response::User.new(client,request_response["user"])
      end

    end
  end
end