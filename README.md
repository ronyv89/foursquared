# Foursquared

Simple client library for Foursquare API V2 with OAuth2 authentication
## Installation

Add this line to your application's Gemfile:

    gem 'foursquared'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foursquared

## Usage

### OAuth2 Authentication

  Foursquare OAuth2 authentication is integrated here.
  First you will have to initialize a Foursquared::OAuth::Client object with the client id, client secret and the callback url

    oauth_client = Foursquared::OAuth::Client.new("your_client_id", "your_client_secret", "http://yourcallbackurl")

  Obtain the authentication url 

    auth_url = oauth_client.authorize_url

  Redirect the user to the above obtained auth_url. After user gives access to your app, they will be redirected to the callback url with a 'code' parameter. Extract this code and get the access token by invoking the following method

    access_token = oauth_client.get_access_token("the_extracted_code")

### Instantiate a client
  
  After getting the access token instantiate the Foursquared client

    client = Foursquared::Client.new(:access_token => "your_acess_token")

  For userless access you can skip the above step and instantiate the client with your client id and client secret. 

    client = Foursquared::Client.new(:client_id => "your_client_id", :client_secret => "your_client_secret")

## Features

1. Every response item is an object. For example, every user will be a Foursquared::Response::User.
2. Each object will have its own actions. For example you can friend, unfriend or deny the request from a user after retrieving the user object.

## Examples

You can always navigate to [the documentation](http://rubydoc.info/gems/foursquared/frames) for a list of all supported methods and available options.

### Get user details

    client.user(10230)

### Get a venue details

    venue = client.venue("4b2afcaaf964a5205bb324e3")

### Checkin at a venue
  
  You can use the above obtained Foursquared::Response::Venue object to checkin

    venue.checkin(:broadcast => 'public', :ll => '36.142064,-86.816086', :shout => 'zomg coffee!1!')

  You can also directly checkin at a venue providing its venue id.

    client.add_checkin(:venueId => "4b2afcaaf964a5205bb324e3", :broadcast => 'public', :ll => '36.142064,-86.816086', :shout => 'zomg coffee!1!')

## Todo
  
  * Add more tests
  * Improve documentation
  * Integrate more endpoints
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

