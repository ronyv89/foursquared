module Foursquared
  class Leaderboard
    def initialize response
      @response = response["leaderboard"]
    end

    def count
      @response["count"]
    end

  end
end