module Foursquared
  # Error class
  class Error < StandardError
    attr_reader :code, :error_type, :error_detail
    def initialize meta
      @code = meta["code"]
      @detail = meta["errorDetail"]
      @type = meta["errorType"]
    end

    # Error message to be displayed on encountering Foursquare::Error
    def message
      "#{type}: #{detail} (#{code})"
    end
  end
end