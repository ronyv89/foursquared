module Foursquared
  module Badges
    def badge(badge_id)
      response = get("/badges/#{badge_id}")["response"]
      Foursquared::Response::Badge.new(self,response["badge"])
    end

    def user_badges(user_id="self")
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