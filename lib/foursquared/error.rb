module Foursquared
  class Error < StandardError
    attr_reader :code, :error_type, :error_detail
    def initialize meta
      @code = meta["code"]
      @detail = meta["errorDetail"]
      @type = meta["errorType"]
    end

    def message
      "Error: #{code}, #{type}, #{detail}"
    end
  end
end