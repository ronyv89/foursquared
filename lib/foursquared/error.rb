module Foursquared
  # Error class
  class Error < StandardError
    attr_reader :code, :type, :detail
    def initialize meta
      @code = meta["code"]
      @detail = meta["errorDetail"]
      @type = meta["errorType"]
    end

    # Error message to be displayed on encountering Foursquare::Error
    def message
      "#{type}: #{detail} (#{code})"
    end
    alias :to_s :message
  end
end