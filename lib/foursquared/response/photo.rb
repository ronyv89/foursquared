module Foursquared
  class Photo
    attr_reader :response
    def initalize response
      @response = response
    end

    def id
      response["id"]
    end

    def created_at
      response["createdAt"]
    end

    def source
      response["source"]
    end

    def prefix
      response["prefix"]
    end

    def width
      response["width"]
    end

    def height
      response["height"]
    end

    def user
      Foursquared::Response::User.new(response["user"]) if response["user"]
    end

    def visibility
      response["visibility"]
    end

    def suffix
      response["suffix"]
    end

    def url width, height
      "#{prefix}#{width}x#{height}#{suffix}"
    end

    def urls
      @urls = {
        "36x36" => url(36,36),
        "100x100" => url(100,100),
        "300x300" => url(300,300),
        "500x500" => url(500,500)
      }
      @urls.merge!({"original" => url(width, height)}) if (width and height)
    end
  end
end