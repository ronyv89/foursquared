module Foursquared
  module Users
    # Get
    def user(user_id=nil)
      response = get("/users/#{user_id ||'self'}")["response"]
      @user = Foursquared::Response::User.new(response["user"]) 
    end

    def leaderboard
      response = get("/users/self/leaderboard")["response"]["leaderboard"]
    end

  end
end