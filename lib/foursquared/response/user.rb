module Foursquared
  module Response
    class User
      attr_reader :response
      def initialize response
        @response = response
      end

      [:id, :relationship].each do |method_name|
        define_method method_name do
          response[method_name.to_s]
        end
      end

      def id
        response["id"]
      end


      def name
        [first_name, last_name].join(' ').strip
      end

      def first_name
        response["firstName"]
      end

      def last_name
        response["lastName"]
      end

      def photo
        response["photo"]
      end

      def gender
        response["gender"]
      end

      def home_city
        response["homeCity"]
      end

      def pings
        fetch unless response.has_key?("pings")
        response["pings"]
      end

      def contact
        fetch unless response.has_key?("contact")
        response["contact"]
      end

      def email
        contact["email"]
      end

      def twitter
        contact["twitter"]
      end

      def facebook
        contact["facebook"]
      end

      def twitter?
        !twitter.blank?
      end

      def facebook?
        !facebook.blank?
      end

      def phone_number
        contact["phone"]
      end

      def badge_count
        fetch unless response.has_key?("badges")
        response["badges"]["count"]
      end

      def mayorships
        fetch unless response.has_key?("mayorships")
        response["mayorships"]["items"]
      end

      def friends(options={})
        get("users/#{id}/friends", options)["friends"]["items"].map do |item|
          Foursquared::Response::User.new(@foursquare, item)
        end
      end
    end
  end
end