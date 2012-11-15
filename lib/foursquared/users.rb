module Foursquared
  module Users
    # Get
    def user(user_id=nil)
      get("/users/#{user_id ||'self'}")
    end
  end
end