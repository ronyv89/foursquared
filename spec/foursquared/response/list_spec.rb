require 'spec_helper'
require 'foursquared/response/list'
describe Foursquared::Response::List do
  let(:list) do
    YAML.load(%{
      meta:
        code: 200
      response:
        list:
          id: "5073f878e4b023c59da80d39"
          name: "TOP MALLS IN KOCHI"
          description: ""
          type: "others"
          user:
            id: 12345
          editable: false
          public: true
          collaborative: false
          url: "https://foursquare.com/user/39000217/list/top-malls-in-kochi"
          canonicalUrl: "https://foursquare.com/user/39000217/list/top-malls-in-kochi"
          createdAt: 1349777528
          updatedAt: 1349778775
          photo:
            id: "5073fb82f2e752674b569b36"
          visitedCount: 1
          venueCount: 1
          following: false
    })
  end

  subject { foursquared_test_client.list("5073f878e4b023c59da80d39") }
  before :each do
    stub_request(:get, "https://api.foursquare.com/v2/lists/5073f878e4b023c59da80d39?oauth_token=TestToken&v=#{Time.now.strftime("%Y%m%d")}").
         to_return(:status => 200, :body => list.to_json, :headers => {})

  end

  it "should return the list id" do
    subject.id.should == "5073f878e4b023c59da80d39"
  end

  it "should return the user who created the list" do
    subject.user.should be_a(Foursquared::Response::User)
    subject.user.id == 12345
  end

  it "should return the photo associated with the list" do
    subject.photo.should be_a(Foursquared::Response::Photo)
    subject.photo.id.should == "5073fb82f2e752674b569b36"
  end

  it "should return the timestamp the photo was created" do
    subject.created_at.should be_a(Time)
  end

end