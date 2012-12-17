module Foursquared
  module Settings
    def setting setting_id
      response = get("/settings/#{setting_id}")["response"]
      response
    end

    def all_settings
      response = get("/settings/all")["response"]
    end

    def set_setting setting_id, options={}
      response = post("/settings/#{setting_id}/set",options)
    end
  end
end