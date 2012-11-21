module Foursquared
  module Users
    # Get
    def user(user_id=nil)
      response = get("/users/#{user_id ||'self'}")["response"]
      @user = Foursquared::Response::User.new(self,response["user"])
    end

    def leaderboard(options={})
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
      define_method method_name do |user_id|
        response = post("/users/#{user_id}/unfriend")["response"]["user"]
        @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
      end
    end
    def requests(options={})
      response = get("/users/requests", options)["response"]["requests"]
      @requests = response.collect{|request| Foursquared::Response::User.new(self,request)}
    end

    def search(options={})
      response = get("/users/search", options)["response"]["results"]
      @results = response.collect{|result| Foursquared::Response::User.new(self,result)}
    end

    def set_pings(user_id, value)
      response = post("/users/#{user_id}/setpings", options={:value => value})["response"]["user"]
      @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
    end

    def update(image_file_name)
      response = post("/users/self/update", options={:photo => File.read(image_file_name)})["response"]["user"]
      @user = response.collect{|user| Foursquared::Response::User.new(self,user)}
    end
  end
end