module Foursquared
  class Error < StandardError
    attr_reader :code, :error_type, :error_detail
    def initialize meta
      @code = meta["code"]
      @detail = meta["errorDetail"]
      @type = meta["errorType"]
    end
  end
end