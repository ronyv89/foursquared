module Foursquared
  module Response
    class Checkin
      attr_reader :client, :response
      def initialize client, response
        @client = client
        @response = response
      end

      [:id, :type, :shout, :source, :score, :like].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      def time_zone_offset
        response["timeZoneOffset"]
      end

      def venue
        Foursquared::Response::Venue.new(client, response["venue"])
      end

      def photos
        response["photos"]["items"].collect{|photo| Foursquared::Response::Photo.new(client, photo)}
      end

      def likes
        likes_response = client.get("/checkins/#{id}/likes")["response"]
        @likes = {}
        if likes_response["likes"]
          @likes.merge!(likes_response["likes"])
          if @likes["groups"]
            @likes["groups"].each do |group|
              group["items"].map!{|item| Foursquared::Response::User.new(client, item)}
            end
          end
        end
        @likes
      end

      def photos
        response["photos"]["items"].collect{|item| Foursquared::Response::Photo.new(client, item)}
      end

      def add_comment(options={})
        response = post("/checkins/#{id}/addcomment", options)["response"]
        @comment = response["comment"]
        @comment["user"] = Foursquared::Response::User.new(@comment["user"])
        @comment
      end

      def delete_comment(comment_id)
        response = post("/checkins/#{id}/deletecomment", {:commentId => comment_id})["response"]
        @checkin = Foursquared::Response::Checkin.new(response["checkin"])
      end

      def like_checkin(value=1)
        response =  post("/checkins/#{id}/like", {:commentId => comment_id, :set => value})["response"]
        likes
      end

    end
  end
end