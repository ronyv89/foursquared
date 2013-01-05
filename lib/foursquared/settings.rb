module Foursquared
  # Settings module
  module Settings

    # Return the value for the setting with given ID
    # @param [String] setting_id ID of the setting
    # @return [Hash] ex: {"value" => "true"}
    def setting setting_id
      response = get("/settings/#{setting_id}")["response"]
      response
    end

    # Returns all settings for the user
    # @return [Hash]
    def all_settings
      response = get("/settings/all")["response"]["settings"]
    end

    # Set the value for a setting
    # @param [String] setting_id ID of the setting
    # @param [Hash] options
    # @option options [Integer] :value 1 for true or 0 for false
    # @return [Hash] With a confirmation message
    def set_setting setting_id, options={}
      response = post("/settings/#{setting_id}/set",options)["response"]
    end
  end
end