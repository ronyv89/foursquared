require 'oauth2'
module Foursquared
  # OAuth module
  module OAuth
    # OAuth Client class
    class Client     
      attr_accessor :client_id, :client_secret, :oauth_client, :callback_url, :access_token
      def initialize(client_id, client_secret, callback_url, opts={}, &block)
        @client_id = client_id
        @client_secret = client_secret
        @callback_url = callback_url
        ssl = opts.delete(:ssl)

        @options = {
                    :site => 'https://foursquare.com/',
                    :authorize_url => '/oauth2/authenticate?response_type=code',
                    :token_url => '/oauth2/access_token',
                    :parse_json => true}.merge(opts)
        @options[:connection_opts][:ssl] = ssl if ssl
        @oauth_client = OAuth2::Client.new(client_id, client_secret, @options)
      end

      # Step 1: URL for OAuth2 oauthorizetion of Foursquare
      # @return [String]
      def authorize_url
        oauth_client.auth_code.authorize_url(:redirect_uri => callback_url)
      end

      # Step 2: Get access token after authorizing user
      # @param [String] code The value extracted from the callback url param 'code'
      def get_access_token code
        token = oauth_client.auth_code.get_token(code, :redirect_uri => callback_url)
        @access_token = token.token
      end
    end
  end
end