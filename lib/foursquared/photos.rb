module Foursquared
  # photos module
  module Photos
    # Return the photo with the given ID
    # @param photo_id The id of the photo
    # @return [Foursquared::Response::Photo]
    def photo photo_id
      response = get("/photos/#{photo_id}")["response"]
      @photo = Response::Photo.new(self, response["photo"])
    end

    # Add a new photo to a checkin, tip, venue, or page update in general. 
    # @param [Hash] options
    # @option options [String] :checkinId the ID of a checkin owned by the user.
    # @option options [String] :tipId the ID of a tip owned by the user.
    # @option options [String] :venueId the ID of a venue, provided only when adding a public photo of the venue in general, rather than a photo for a private checkin, tip, or page update.
    # @option options [String] :pageId the ID of a page, provided only when adding a photo that will be in an update for that page
    # @option options [String] :broadcast Whether to broadcast this photo example: twitter,facebook
    # @option options [Integer] :public When the checkinId is also provided this parameter allows for making the photo public and viewable at the venue. 1 or 0
    # @option options [String] :ll Latitude and longitude of the user's location.
    # @option options [String] :llAcc Accuracy of the user's latitude and longitude, in meters.
    # @option options [String] :alt Altitude of the user's location, in meters.
    # @option options [String] :altAcc Vertical accuracy of the user's location, in meters.
    # @option options [String] :postUrl A link for more details about the photo. 
    # @option options [String] :postContentId Identifier for the photo post to be used in a native link
    # @option options [String] :postText Text for the photo post, up to 200 characters. A checkinId must also be specified in the request.
    # @return [Foursquared::Response::Photo] The photo that was just created.
    def add_photo options={}
      response = post("/photos/add", options)["response"]
      @photo = Response::Photo.new(self, response["photo"])
    end

  end
end