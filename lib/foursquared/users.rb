module Foursquared
  module Users

    # Return the user with given user id
    def user user_id="self"
      response = get("/users/#{user_id}")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    def leaderboard options={}
      response = get("/users/leaderboard", options)["response"]["leaderboard"]
      @leaderboard = {"count" => response["count"], "items" => []}
      response["items"].each do |item|
        leaderboard_item = {}
        leaderboard_item["user"] = Foursquared::Response::User.new(self,user)
        leaderboard_item["scores"] = item["scores"]
        leaderboard_item["rank"] = item["rank"]
        @leaderboard["items"] << leaderboard_item
      end
      @leaderboard
    end

    [:approve, :deny, :request, :unfriend].each do |method_name|
      define_method "user_#{method_name}".to_sym do |user_id|
        response = post("/users/#{user_id}/#{method_name}")["response"]["user"]
        @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
      end
    end

    def requests options={}
      response = get("/users/requests", options)["response"]["requests"]
      @requests = response.collect{|request| Foursquared::Response::User.new(self,request)}
    end

    def search options={}
      response = get("/users/search", options)["response"]["results"]
      @results = response.collect{|result| Foursquared::Response::User.new(self,result)}
    end

    def set_pings user_id, value
      response = post("/users/#{user_id}/setpings", options={:value => value})["response"]["user"]
      @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
    end

    def update image_file_name
      response = post("/users/self/update", options={:photo => File.read(image_file_name)})["response"]["user"]
      @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
    end

    def user_checkins user_id="self", options={}
      response = get("/users/#{user_id}/checkins",options)["response"]
      response["checkins"]["items"].map!{|checkin| Foursquared::Response::Checkin.new(self, checkin)} if response["checkins"] and response["checkins"]["items"]
      response
    end


    def user_friends user_id="self", options={}
      response = get("/users/#{user_id}/friends")["response"]
      response["friends"]["items"].map!{|friend| Foursquared::Response::User.new(self, friend)} if response["friends"] and response["friends"]["items"]
      response
    end

    def user_lists user_id="self", options={}
      response = get("/users/#{user_id}/lists")["response"]
      @lists = response["lists"]
      @lists["groups"].each do |group|
        group["items"].map!{|item| Foursquared::Response::List.new(self, item)}
      end
      @lists
    end

    def user_mayorships user_id="self", options={}
      response = get("/users/#{user_id}/mayorships")["response"]
      @mayorships = response["mayorships"]
      @mayorships["items"].each{|item| item["venue"] = Foursquared::Response::Venue.new(self, item["venue"])}
      @mayorships
    end

    def user_photos user_id="self", options={}
      response = get("/users/#{user_id}/photos")["response"]
      @photos = response["photos"]
      @photos["items"].map!{|item| Foursquared::Response::Photo.new(self, item)}
    end

  end
end