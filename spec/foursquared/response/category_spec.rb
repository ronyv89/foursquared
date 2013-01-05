require 'spec_helper'
require 'foursquared/response/category'

describe Foursquared::Response::Category do

  let(:event_category) do
    YAML.load(%{
          id: "4dfb90c6bd413dd705e8f897"
          name: "Movies"
          pluralName: "Movies"
          shortName: "Movie"
          icon:
            prefix: "https://foursquare.com/img/categories_v2/arts_entertainment/movietheater_"
            suffix: ".png"
          categories:
          - id: "4e132f48bd41026cd50e8f8e"
            name: "Baseball Games"
            pluralName: "Baseball Games"
            shortName: "Baseball"
            icon:
              prefix: "https://foursquare.com/img/categories_v2/arts_entertainment/stadium_baseball_"
              suffix: ".png"
            categories: []
      }
    )
  end

  subject {Foursquared::Response::Category.new(event_category)}

  describe "#icon" do
    it "should have prefix, suffix and urls" do
      subject.icon.keys.should ~ ["urls", "prefix", "suffix", ]
    end

    describe "urls" do
      it "should have urls for 32x32, 64x64 and 256x256 icons" do
        subject.icon["urls"].keys.should ~ ["32x32", "64x64", "256x256"]
      end
    end

  end

  it "should give the sub categories of the category" do
    subject.categories.should each { |category|
      category.should be_a(Foursquared::Response::Category)
    }
  end
end