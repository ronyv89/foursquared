require 'httparty'
directory = File.expand_path(File.dirname(__FILE__))

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
  require 'foursquared/oauth/client'
  require 'foursquared/client'
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