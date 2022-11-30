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
    expect(response.body).to include('<h1>You have successfully made an entry.</h1>')

    new_response = get("/albums")
    expect(new_response.status).to eq 200
    expect(new_response.body).to include("Voyage")
  end

  it "Throws an error if invalid input for album" do
    response = post("/albums", release_year: "2022", artist_id: "2")
    expect(response.status).to eq 400
  end

  it "Album list 2 reproduces the album" do
    response = get("/albumslist/2")
    expect(response.status).to eq 200 
    expect(response.body).to include("<h1>Surfer Rosa</h1>")
  end
  
  it "Gets all albums and prints them" do
    response = get("/allalbums")
    expect(response.status).to eq 200
    expect(response.body).to include('<a href="/albumslist/7"> Folklore </a>')
    expect(response.body).to include('<a href="/albumslist/12"> Ring Ring </a>')
  end

  it "Produces a page of all the artists" do
    response = get("/artists")
    expect(response.status).to eq 200
    expect(response.body).to include ('<a href="/artists/1"> Pixies </a>')
    expect(response.body).to include('<a href="/artists/3"> Taylor Swift </a>')

  end

  it "Produces a page for the individual artists" do
    response = get("/artists/2")
    expect(response.status).to eq 200 
    expect(response.body).to include("<h1>ABBA</h1>")
  end

  it "Adds an artist" do 
    response = post("/artists?name=Wild%20Nothing&genre=Indie")
    expect(response.status).to eq 200
    response = get("/artists")
    expect(response.body).to include("Wild Nothing")
  end

  it "Has an add page for albums" do
    response = get("/albums/add")
    expect(response.status).to eq 200
    expect(response.body).to include("<h1> Add an album!</h1>")
    expect(response.body).to include('<form action="/albums"')
  end
end 
