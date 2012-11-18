module Foursquared
  module Lists
    def list(list_id)
      response = get("/lists/#{list_id}")["response"]
      @list = Foursquared::Response::List.new(response["list"])
    end

  end
end
