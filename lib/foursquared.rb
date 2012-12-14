require 'httmultiparty'
require 'json'
directory = File.expand_path(File.dirname(__FILE__))
require 'core_ext/symbol'
module Foursquared
  class << self

    FIELDS = [ :client_id, :client_secret, :api_version,
               :ssl, :access_token, :locale ]
    attr_accessor(*FIELDS)


    def configure
      yield self
      true
    end
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
  require 'foursquared/oauth/client'
  require 'foursquared/client'
  require 'foursquared/response/user'
  require 'foursquared/response/list'
  require 'foursquared/response/photo'
  require 'foursquared/response/venue'
  require 'foursquared/response/checkin'
  require 'foursquared/response/badge'
  require 'foursquared/response/badge_group'
  require 'foursquared/response/event'
  require 'foursquared/response/event_category'
  require 'foursquared/error'

  # require 'foursquare2/specials'
  # require 'foursquare2/settings'
  # require 'foursquare2/photos'
  # require 'foursquare2/tips'
  # require 'foursquare2/checkins'
  # require 'foursquare2/venues'
  # require 'foursquare2/pages'
  # require 'foursquare2/lists'
  # require 'foursquare2/events'
  # require 'foursquare2/client'
  # require 'foursquare2/api_error'


end

include Foursquared::Response
