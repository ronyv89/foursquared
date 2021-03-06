require 'httmultiparty'
require 'json'
directory = File.expand_path(File.dirname(__FILE__))
module Foursquared
  class << self

    attr_accessor :client_id, :client_secret, :api_version, :ssl, :access_token, :locale 
    
  end

  # require 'foursquare2/campaigns'
  require 'foursquared/users'
  require 'foursquared/photos'
  require 'foursquared/lists'
  require 'foursquared/checkins'
  require 'foursquared/venues'
  require 'foursquared/badges'
  require 'foursquared/events'
  require 'foursquared/pages'
  require 'foursquared/specials'
  require 'foursquared/settings'
  require 'foursquared/tips'
  require 'foursquared/oauth/client'
  require 'foursquared/client'
  require 'foursquared/response/user'
  require 'foursquared/response/list'
  require 'foursquared/response/list_item'
  require 'foursquared/response/photo'
  require 'foursquared/response/venue'
  require 'foursquared/response/checkin'
  require 'foursquared/response/badge'
  require 'foursquared/response/badge_group'
  require 'foursquared/response/event'
  require 'foursquared/response/category'
  require 'foursquared/response/special'
  require 'foursquared/response/tip'
  require 'foursquared/error'

end

include Foursquared::Response
