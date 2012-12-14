require 'spec_helper'
require 'foursquared/pages'

describe Foursquared::Pages do

  let(:page) do
    YAML.load(%{
        meta:
          code: 200
        response:
          user:
            id: "1070527"
            firstName: "Starbucks"
            type: "chain"
            followers:
              groups:
              - type: "friends"
                name: "Liked by 2 friends"
                items:
                - id: "36332988"
                  firstName: "Sree"
                  lastName: "Ram"
                  relationship: "friend"
                -id: "38283243"
                  firstName: "Vineeth"
                  lastName: "Nix"
                  relationship: "friend"
      }
    )
  end

  subject { foursquared_test_client }
end