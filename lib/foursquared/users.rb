module Foursquared
  module Users
    # Get
    def user(user_id=nil)
      response = get("/users/#{user_id ||'self'}")["response"]
      @user = Foursquared::Response::User.new(response["user"])
    end

    def leaderboard(options={})
      response = get("/users/leaderboard", options)["response"]["leaderboard"]
      @leaderboard = {"count" => response["count"], "items" => []}
      response["items"].each do |item|
        leaderboard_item = {}
        leaderboard_item["user"] = Foursquared::Response::User.new(user)
        leaderboard_item["scores"] = item["scores"]
        leaderboard_item["rank"] = item["rank"]
        @leaderboard["items"] << leaderboard_item
      end
      @leaderboard
    end

    def requests(options={})
      response = get("/users/requests")["response"]["requests"]
      @requests = response.collect{|request| Foursquared::Response::User.new(request)}
    end
  end
end