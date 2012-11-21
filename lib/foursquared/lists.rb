module Foursquared
  module Lists
    def list(list_id)
      response = get("/lists/#{list_id}")["response"]
      @list = Foursquared::Response::List.new(self, response["list"])
    end

    def add_list(name, options={})
      response = post("/lists/add", options)["response"]
      @list = Foursquared::Response::List.new(self, response["list"])
    end

  end
end
