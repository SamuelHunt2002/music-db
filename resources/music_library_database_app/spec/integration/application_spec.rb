require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  it "Gets the albums" do
    new_response = get("/albums")
    expect(new_response.status).to eq 200
    expect(new_response.body).to include("Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring")
  end

  it "Posts a new album" do
    response = post("/albums", title: "Voyage", release_year: "2022", artist_id: "2")
    expect(response.status).to eq 200
    expect(response.body).to eq ''

    new_response = get("/albums")
    expect(new_response.status).to eq 200
    expect(new_response.body).to include("Voyage")
  end
end
