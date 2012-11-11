module Foursquared
  module Users
    # Get 
    def user(user_id=nil)
      get("/users/#{user_id||'self'}").methods.to_s
    end
  end
end